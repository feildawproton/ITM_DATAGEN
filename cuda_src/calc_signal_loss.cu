#include "raytrace_maxheight.cuh"
#include "calc_loss_funcs.cuh"
#include <math.h>

__global__ void calc_losses(
	const int source_x, const int source_y, const int source_z, 
	const float *height_map, float *pLoss, const int y_size, const int x_size, 
	const unsigned y_threads, const unsigned x_threads, const float freq)
{
	int h_1 = source_z;
	
	unsigned gind_y = threadIdx.y + blockIdx.y * blockDim.y;
	unsigned gind_x = threadIdx.x + blockIdx.x * blockDim.x;
	
	for(int dest_y = gind_y; dest_y < y_size; dest_y += y_threads)
	{
		for(int dest_x = gind_x; dest_x < x_size; dest_x += x_threads)
		{
			float h_0 = raytrace_maxheight_f(source_x, source_y, dest_x, dest_y, y_size, height_map);
			
			int flat_idx	= dest_x * y_size + dest_y;		//I think it's column major
			float h_2	= height_map[flat_idx];
			
			Height_Results results = raytrace_maxheight_f(source_x, source_y, dest_x, dest_y, y_size, height_map);
			
			float x_t_o	= (float)(results.ind_x - source_x) * .1;	//100 meters per pixel. distance in kilometers
			float y_t_o	= (float)(results.ind_y - source_y) * .1;
			float d_1	= sqrtf((x_t_o * x_t_o) + (y_t_o * y_t_o));
			
			float x_o_r	= (float)(dest_x - results.ind_x) * .1;	//100 meters per pixel. distance in kilometers
			float y_o_r	= (float)(dest_y - results.ind_y) * .1;
			float d_2	= sqrtf((x_o_r * x_o_r) + (y_o_r * y_o_r));
			
			float loss	= calc_loss(h_0, h_1, h_2, d_1, d_2, freq);
			pLoss[i]	= loss  
		}
	} 
}

extern "C" 
{
//source_z should be the abosolute height of the emmiter, not it's height over the ground
void signal_loss(const int source_x, const int source_y, const int source_z, const float *height_map, float *pLoss, const int y_size, const int x_size)
{
	size_t mem_size = y_size * x_size * sizeof(float);
	float *height_map_dev, *pLoss_dev;
	
	cudaError_t status;
	status = cudaMalloc((void**)&height_map_dev, mem_size);
	status = cudaMalloc((void**)&pLoss_dev, mem_size);
	
	status = cudaMemcpy(height_map_dev, height_map, mem_size, cudaMemcpyHostToDevice); 
	status = cudaMemcpy(pLoss_dev, pLoss, mem_size, cudaMemcpyHostToDevice); 
	
	// -- Skipping multi-gpu or multi-stream for this --
	
	int deviceID;								//get device ID
	cudaGetDevice(&deviceID);
	cudaDeviceProp props;							//get device properties
	cudaGetDeviceProperties((void**)&props, deviceID);
	unsigned ThreadsPerBlock	= props.warpSize * 4;			//threads per block should be soe multiple of warpsize or just set to props.maxThreadsPerBlock
	unsigned BlocksPerGrid		= props.multiProcessorCount * 2;	
	
	calc_losses<<<BlocksPerGrid, ThreadsPerBlock>>>
	
	cudaDeviceSynchronize();
	
	cudaFree(pLoss_dev);
	cudaFree(height_map_dev);
}

}
