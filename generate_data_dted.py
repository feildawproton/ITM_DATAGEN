'''
import random
import numpy as np
import sys
import cv2


height_map = np.random.rand(512,512)
height_map = height_map.astype("float32")


cv2.imshow("Height Data", height_map)
cv2.waitKey(0)
cv2.destroyAllWindows()
'''


import numpy as np
from pathlib import Path
from dted import Tile

import cv2

dted_file = Path("dted_data/Boston/n52_e000_1arc_v3.dt2")
tile = Tile(dted_file)
assert isinstance(tile.data, np.ndarray)

max_height = np.max(tile.data)
min_height = np.min(tile.data)
print(max_height)
print(min_height)



tile_scaled = (tile.data.astype("float32") - min_height) / (max_height - min_height)

max_height = np.max(tile_scaled)
min_height = np.min(tile_scaled)
print(max_height)
print(min_height)

cv2.imshow("Height Data", tile_scaled)
cv2.waitKey(0)

sys.exit()
cv2.destroyAllWindows()

