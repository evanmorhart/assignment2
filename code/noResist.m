function noResist(nx,ny, boundY, maxN)
%NORESIST Electronstatic simulation excluding high resistivity regions
%   noResist(nx,ny, boundY, maxN)
%   Inputs:
%       nx - number of x elements in the solution matrix
%		my - number of y elements in the solution matrix
%		boundY - flag denoting if the y values are bound to 0 volts
%		maxN   - Maximum value for n to use when calculating analytical solution

solutMat = zeros(nx,ny);
solutVect = zeros(nx*ny,1);
G = sparse(nx*ny, nx*ny);

for i = 1:nx
	for j = 1:ny
		n = j+(i-1)*ny;

		%
		if i == 1
			solutVect(n) = 1;
			G(:,n) = 0;
			G(n,n) = 1;
		elseif i == nx
			if boundY ~= 1
				solutVect(n) = 1;
			end
			G(:,n) = 0;
			G(n,n) = 1;
		elseif j == 1 %handle y cases

			if boundY == 1 %1D case
				nxm = j+(i-2)*ny;
            	nxp = j+(i)*ny;

            	G(n,n) = -2;
            	G(n,nxm) = 1;
            	G(n,nxp) = 1;
			else %2D case
				G(n,:) = 0;
				G(n,n) = 1;

			end

		elseif j == ny 

			if boundY == 1 %1D case
				nxm = j+(i-2)*ny;
            	nxp = j+(i)*ny;

            	G(n,n) = -2;
            	G(n,nxm) = 1;
            	G(n,nxp) = 1;
			else %2D case
				G(n,:) = 0;
				G(n,n) = 1;

			end
		else %Handle standard middle cases
			nxm = j+(i-2)*ny;
            nxp = j+(i)*ny;
            nym = (j-1)+(i-1)*ny;
            nyp = (j+1)+(i-1)*ny;            
            
            G(n,n) = -4;
            G(n,nxm)= 1;
            G(n,nxp) = 1;
            G(n,nym) = 1;
            G(n,nyp) = 1;
		end
	end
end

solutVect = G\solutVect;

for i = 1:nx
	for j = 1:ny
		n= j+(i-1)*ny;
		solutMat(i,j) = solutVect(n);
	end
end
figure()
surf(solutMat, 'edgecolor', 'none')
rotate3d on;

if boundY == 1 
	title("Solution to Laplace's Equation by Finite Difference with Unbound Y Dimension", 'Interpreter', 'Latex');
else
	title("Solution to Laplace's Equation by Finite Difference with Grounded Y Dimension", 'Interpreter', 'Latex');
end
ylabel('L', 'Interpreter', 'Latex');
xlabel('W', 'Interpreter', 'Latex');
zlabel('V (Volts)', 'Interpreter', 'Latex');
set(gca, 'FontSize', 15);


%Analytical solution for comparison
%Mesh size relies on size of dimensions, similar to the G matrix solution method
%This spacing also sets a and b in the analytical solution to 1

V = zeros(nx, ny); %Swapped because of Matlab's handling of rows columns

analytical = @(x,y,n) (1./n)*sin(n.*pi.*y).*cosh(n.*pi.*x)./cosh(n.*pi);

%.*cosh(n.*pi.*x).*sin(n.*pi.*y)./cosh(n.*pi);

% figure()
% surf(V, 'edgecolor', 'none');
% for k = 1:2:maxN
% 	for i = 1:nx 
% 		for j = 1:ny
% 			V(i, j) = V(i,j) + analytical(i, j, k);			

% 		end
% 	end
% 	surf(V, 'edgecolor', 'none');
% 	title(num2str(k));
% 	pause(1);
% end

% V = 4./pi.*V;
% surf(V, 'edgecolor', 'none');


end

