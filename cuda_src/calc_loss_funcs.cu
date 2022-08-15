#include "calc_loss_funcs.cuh"
#include <math.h>

//this is based off of Nicole Patterson's right up on Signal Propagation Equations for ITM
//this function (insert here) takes arrays a parameters, each index representing a single examples
//and returns a array of power losses, each eantry being the result for a single example

//this functions calculates a vaiable h
//as far as I can tell this is alse C_obs
__device__ float calc_h(const float h_0, const float h_1, const float h_2, const float d_1, const float d_2)
{
	//h_ER is the height of the surface curvature at the obstruction point in meters
	float h_ER = (d_1 * d_2) / 16.944;
	float h = h_0 + h_ER - h_1 - ((h_2 - h_1) / (d_1 + d_2))*d_1;
	return h;
}

//lambda is the wavelenght
__device__ float calc_lambda(float freq)
{
	return (299792458.0 / freq);
}


//v is the geometry factor
__device__ float calc_v(const float h_0, const float h_1, const float h_2, const float d_1, const float d_2, const float freq)
{
	//lambda is the wavelenght
	float lam = calc_lambda(freq);
	float h = calc_h(h_0, h_1, h_2, d_1, d_2);
	
	//v is the geometry factor
	//using sqrtf to ensure float version.  even though nvcc will perform it's own insertion
	float v = h * sqrtf((2.0*(d_1 + d_2)) / (lam * d_1 * d_2));
	return v;
}

//R_FR is 60% of the first Fresnel Zone radius
__device__ float calc_R_FR(const float d_1, const float d_2, const float freq)
{
	float f_MHz = freq / 1000000.0;
	//using sqrtf to ensure float version.  even though nvcc will perform it's own insertion
	float R_FR = 0.6*(547.533*sqrtf((d_1*d_2) / (f_MHz*(d_1 + d_2) ) ) );
	return R_FR;
}

//this is the loss for a single example
//h_0 is the height of the obstruction in METERS
//h_1 is the height of the transmitter in METERS
//h_2 is the height of the receiver in METERS
//d_1 is the distance from the transmitter the obstruction point in KILOMETERS
//d_2 is the distance from the obstruction to the receiver in KILOMETERS
//freq is the frequency in Hertz (1/s)
__device__ float calc_loss(const float h_0, const float h_1, const float h_2, const float d_1, const float d_2, const float freq)
{
	float loss = 0.0;
	
	//v is the geometry factor
	float v = calc_v(h_0, h_1, h_2, d_1, d_2, freq);
	
	//accumulate loss from these various factors
	//FSPL loss occurs in the Fresnel Zone
	if(v <= -1.0)
	{
		//assumig the base is 10
		//using the float version instead of the default double version
		//hopefully nvcc makes the appropriate replacements
		float f_GHz = freq / 1000000000.0;
		loss += 20.0 * log10f(d_1 + d_2) + 20.0 * log10f(f_GHz) + 92.45;
	}
	//LOS loss occurs when the Freznel Zone is obstructed but the LOS line remains unobstructed
	if(v > 0.0 && v < 1.0)
	{
		//C_obs is the distance betweent he LOS and the obstruction
		float C_obs = calc_h(h_0, h_1, h_2, d_1, d_2);
		//R_FR is 60% of the first Fresnel Zone radius
		float R_FR = calc_R_FR(d_1, d_2, freq);
		loss += 6.0*(1.0 - (C_obs / R_FR));
	}
	//NLOS occurs whe the LOS is obstructed
	if(v >= 0.0)
	{
		//using log10f base 10
		//using float version of both log and sqrt
		loss += 6.9 + 20.0*log10f(sqrtf((v-0.1)*(v-0.1) + 1.0) + v - 0.1);
	}
	return loss;	
}
