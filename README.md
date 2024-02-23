# NO-ZEROS-IDL - E. Tirado-Bueno & D. Godos-Valencia

# Purpose:
Procedure to get an array of float data with some gaps and replaced them with the mean of the pixels before and after.
# Explanation:
From a vector of integer or float data, zeros in the pixels are searched. After that, sections of zeros are identified. From the pixels around this sections, the mean is stablished for each gap. Then these sections are replaced with the mean. After that, a vector of float data with no zeros is obtained.
# Calling Sequence:
results = no_zeros(vect, constant, replace)
# Inputs:
vect - input vector from which we want to remove the zeros. Float or integer type.
constant - in case the whole vector is filled with zeros, it is changed for another constant.
replace - in case the zeros are expected to be changed for another value.
# Outputs:
The new vector without zeros is returned as the function value.
Output is -1 if vector is not integer neither float type.
If the constant is omitted from the input, in case the vector is whole with zeros, you may get the same vector.
In case replace has some value, it would be the value that substitute the zero pixel.
# Keyword Outputs:
BAD_VECT set to 1B if is not integer neither float type.
