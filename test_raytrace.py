import random
import numpy as np

#in grid space, the length of a vector is equal to longset scaler componet
#so we can create a list of indices of lenth ||H||  + 1 (to include the dest indices)
#we can then loop through this list to find the maximum height
def raytrace_maxheight(source_x, source_y, dest_x, dest_y, height_map):
	x_signed_len = dest_x - source_x
	y_signed_len = dest_y - source_y
	length = max(abs(x_signed_len), abs(y_signed_len))
	max_height = -9999.0	
	for offset in range(length + 1):
		fraction = offset/length;
		x = int(round(x_signed_len * fraction + source_x))
		y = int(round(y_signed_len * fraction + source_y))
		height = height_map[x, y]
		print("python height at %i, %i: %f" % (x, y, height))
		if height > max_height:
			max_height = height
	return max_height
	
'''	
source_x = random.randint(-9, 9)
source_y = random.randint(-9, 9)
dest_x = random.randint(-9, 9)
dest_y = random.randint(-9, 9)
'''

source_x = random.randint(0, 19)
source_y = random.randint(0, 45)
dest_x = random.randint(0, 19)
dest_y = random.randint(0, 45)

print((source_x, source_y, dest_x, dest_y))

height_map = np.random.rand(20,46)
height_map = height_map.astype("float32")

print(height_map[source_x, source_y])
print(height_map[dest_x, dest_y])


max_height_python = raytrace_maxheight(source_x, source_y, dest_x, dest_y, height_map)

print("max height from python code: %f" % (max_height_python))

#c section

import ctypes
from ctypes import *

def get_raytrace():
	dll = ctypes.CDLL("raytrace_maxheight.so", mode = ctypes.RTLD_GLOBAL)
	func = dll.raytrace_maxheight_f
	func.argtype = [c_int, c_int, c_int, c_int, c_int, POINTER(c_float)]
	func.restype = c_float
	return func

def get_bent():
	dll = ctypes.CDLL("raytrace_maxheight.so", mode = ctypes.RTLD_GLOBAL)
	func = dll.accept
	func.argtype = [c_int, c_int, c_int, c_int, POINTER(c_float)]
	func.restype = c_float
	return func
	
c_raytrace = get_raytrace()

c_bent = get_bent()

print(height_map.dtype)

#i_source_x = source_x.ctypes.data_as(c_int)
#i_source_y = source_y.ctypes.data_as(c_int)
#i_dest_x = dest_x.ctypes.data_as(c_int)
#i_dest_y = dest_y.ctypes.data_as(c_int)
p_height_map = height_map.ctypes.data_as(POINTER(c_float))

#conversion to ctypes seems to make the array column major
c_max_height = c_raytrace(source_x, source_y, dest_x, dest_y, height_map.shape[1], p_height_map)
print("max height from c is: %f" % (c_max_height))



c_test = c_bent(source_x, source_y, dest_x, dest_y, p_height_map)
print((height_map[0][0], p_height_map[0], c_test))
