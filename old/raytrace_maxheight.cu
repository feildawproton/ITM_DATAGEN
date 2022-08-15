#include <math.h>
#include <stdio.h>

extern "C" 
{
__host__ __device__ 
float raytrace_maxheight_f(const int source_x, const int source_y, const int dest_x, const int dest_y, const int map_y_size, const float *height_map)
{
	const int x_signed_len = dest_x - source_x;
	const int y_signed_len = dest_y - source_y;
	const int length = max(abs(x_signed_len), abs(y_signed_len));
	float max_height = -99999.0;
	
	for(int offset = 0; offset < (length + 1); offset++)			//length + 1 to include endpoint
	{
		float fraction = (float)offset / (float)length;
		int x = (int)roundf(x_signed_len * fraction + source_x);
		int y = (int)roundf(y_signed_len * fraction + source_y);
		int i = x * map_y_size + y;					//seems to be column major
		float height = height_map[i];
		//printf("c height for %i, %i, : %f\n", x, y, height);
		if(height > max_height)
			max_height = height;
	}
	
	return max_height;
}

float accept(const int bent, const int tint, const int gent, const int went, const float *height_map)
{
	return height_map[0];
}
}

