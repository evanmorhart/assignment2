function [transformed] = vectTransform(nx, ny, input, transDirection)
	%vectTransform transform vector to solution matrix or vice versa
%   vectTransform(nx, ny, input, transDirection)
%   Inputs:
%		nx - number of x elements in matrix form
%		ny - number of y elements in matrix form
%       input - input vector or matrix
%		transDirection - denotes either matrix->vect or vect->matrix
%	Outputs:
%		transformed - transformed result using scheme found in lecture slides



%1 is matrix->vect
if transDirection == 1
	transformed = zeros(nx*ny,1);

	for i = 1:nx
		for j = 1:ny
			%Transform equation
			n = j + (i-1)*ny;
			transformed(n) = input(i,j);
		end
	end
else %matrix->vect case
	transformed = zeros(nx,ny);

	for i = 1:nx
		for j = 1:ny
			%Transform equation
			n = j + (i-1)*ny;
			transformed(i,j) = input(n);
		end
	end
end