#ifndef CALC_LOSS_FUNCS_CUH
#define CALC_LOSS_FUNCS_CUH

//this is the loss for a single example
//h_0 is the height of the obstruction in METERS
//h_1 is the height of the transmitter in METERS
//h_2 is the height of the receiver in METERS
//d_1 is the distance from the transmitter the obstruction point in KILOMETERS
//d_2 is the distance from the obstruction to the receiver in KILOMETERS
//freq is the frequency in Hertz (1/s)
__device__ float calc_loss(const float h_0, const float h_1, const float h_2, const float d_1, const float d_2, const float freq);

#endif
