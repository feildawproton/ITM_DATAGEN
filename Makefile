
build_test_raytrace: raytrace_maxheight.cu
	nvcc -Xcompiler -fPIC -shared -o raytrace_maxheight.so raytrace_maxheight.cu
	
