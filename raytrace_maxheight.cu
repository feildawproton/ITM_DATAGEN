#include "math.h"

__host__ __device__ __forceinline__
void raytrace_maxheight(const uint64_t const uint64_t source_x, const uint64_t source_y, const uint64_t dest_x, const uint64_t dest_y, float** height_map)
{
	const uint64_t x_signed_len = dest_x - source_x;
	const uint64_t y_signed_len = dest_y - source_y;
	const uint64_t length = max(abs(x_signed_len), abs(y_signed_len));
	float max_height = -9999.0;
	for(uint64_t offset = 0; offset < (length + 1); offset++)			//length + 1 to include endpoint
	{
		float fraction = ((float)offset) / ((float)length);
	}
}


