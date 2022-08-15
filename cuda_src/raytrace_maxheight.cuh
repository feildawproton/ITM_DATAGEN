#ifndef RAYTRACE_MAXHEIGHT_CUH 
#define RAYTRACE_MAXHEIGHT_CUH

#include <math.h>
//#include <stdio.h>

struct Height_Results
{
	float max_height;
	int ind_x, ind_y;
};
typedef struct Height_Results Height_Results;

__host__ __device__ __forceinline__
Height_Results raytrace_maxheight_f(const int source_x, const int source_y, const int dest_x, const int dest_y, const int map_y_size, const float *height_map)
{
	const int x_signed_len = dest_x - source_x;
	const int y_signed_len = dest_y - source_y;
	const int length = max(abs(x_signed_len), abs(y_signed_len));
	
	Height_Results results;
	results.max_height 	= -99999.0;
	results.ind_x		= dest_x;
	results.ind_y		= dest_y;
	
	for(int offset = 0; offset < (length + 1); offset++)			//length + 1 to include endpoint
	{
		float fraction = (float)offset / (float)length;
		int x = (int)roundf(x_signed_len * fraction + source_x);
		int y = (int)roundf(y_signed_len * fraction + source_y);
		int i = x * map_y_size + y;					//seems to be column major
		float height = height_map[i];
		//printf("c height for %i, %i, : %f\n", x, y, height);
		if(height > max_height)
			results.max_height	= height;
			results.ind_x		= x;
			results.ind_y		= y;
	}
	
	return results;
}

#endif
