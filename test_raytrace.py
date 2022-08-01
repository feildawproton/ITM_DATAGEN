import random
import numpy as np

#in grid space, the length of a vector is equal to longset scaler componet
#so we can create a list of indices of lenth ||H||  + 1 (to include the dest indices)
#we can then loop through this list to find the maximum height
def raytrace_maxheight(source_x, source_y, dest_x, dest_y, height_map):
	x_signed_len = dest_x - source_x
	y_signed_len = dest_y - source_y
	length = max(abs(x_signed_len), abs(y_signed_len))	
	for offset in range(length + 1):
		fraction = offset/length;
		x = int(round(x_signed_len * fraction + source_x))
		y = int(round(y_signed_len * fraction + source_y))
		height = height_map[x, y]
		print((x,y))
	
'''	
source_x = random.randint(-9, 9)
source_y = random.randint(-9, 9)
dest_x = random.randint(-9, 9)
dest_y = random.randint(-9, 9)
'''

source_x = random.randint(0, 19)
source_y = random.randint(0, 19)
dest_x = random.randint(0, 19)
dest_y = random.randint(0, 19)

print((source_x, source_y, dest_x, dest_y))

height_map = np.random.rand(20,20)

print(height_map[source_x, source_y])
print(height_map[dest_x, dest_y])

raytrace_maxheight(source_x, source_y, dest_x, dest_y, height_map)


