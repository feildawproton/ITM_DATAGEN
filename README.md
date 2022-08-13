# ITM_DATAGEN
Generating synthetic ITM data quickly

## Ray trace to find max height
This 2d raytrace takes advantage of the fact that:

	len(ray) = max(abs(len_x_ray), abs(len_y_ray))
	
The function searchs for max heigh over a list of (X,Y) where:

	x_i = int(x_signed_len * frac_i + x_source))
	y_i = int(y_signed_len * frac_i + y_source))
	
where,

	frac_i = \frac{offset_i}{length}
	for(offset_i = 0; offset_i < length + 1; offset_i++)
and,

	x_signed_len = x_dest - x_source
	y_digned_len = y_dest - y_source
	
And then just keeps track of the maximum height along the list (X,Y).
	
