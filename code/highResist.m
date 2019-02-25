function highResist(lowCond,highCond, bottleL, bottleW)
%HIGHRESIST Electronstatic simulation including high resistivity regions to create bottleneck
%   highResist(lowCond,highCond, bottleL, bottleW)
%   Inputs:
%       lowCond - value for the conductivity of the high resistive area
%		highCond - value for the conductivity of the low resistive are
%		bottleL - Length of the bottleneck created by the resistive squares
%		bottleW - Width of the bottleneck created by the resistive squares

%Set L and W to a constant size, only change size of resistive region
nx = 300;
ny = 200;

xLowBound = (nx./2 - bottleL./2);
xHighBound = (nx./2 + bottleL./2);
yHighBound = (ny./2 + bottleW./2);
yLowBound = (ny./2 - bottleW./2);

%set up conduction mapping
cmap = zeros(nx,ny);
for i = 1:nx
	for j = 1:ny
		if ((i <= xHighBound && i >= xLowBound) && (j <= yLowBound || j >= yHighBound))
			cmap(i,j) = lowCond;
		else
			cmap(i,j) = highCond;
        end
    end
end

surf(cmap, 'edgecolor','none');
title('Conduction Map for Bottle Neck of Width 50 Units and Length 50 Units', 'Interpreter', 'Latex');
xlabel('X Dimension (Units)', 'Interpreter', 'Latex');
ylabel('Y Dimension (Units)', 'Interpreter', 'Latex');
set(gca, 'FontSize', 15);

%Generate and populate G matrix
solutMat = zeros(nx,ny);
solutVect = zeros(1,nx*ny);
G = sparse(nx*ny, nx*ny);

for i = 1:nx
	for j = 1:ny

		%Use the same mapping convention as noResist portion
		n = j+(i-1)*ny;

		%Fix one end of the x at 1 V, the other at ground to find current
		if i == 1
			solutVect(n) = 1;
			G(n,n) = 1;
		elseif i == nx
			%Ground other end
			G(n,n) = 1;
		elseif j == 1
			nLowX = j+(i-2)*ny;
			nHighX = j+i*ny;
			nHighY = (j+1)+(i-1)*ny;

			%Generate values for the resistances as a simple average, considers transitions
			%Between materials
			rLowX = (cmap(i,j) + cmap(i-1,j))./2.0;
			rHighX = (cmap(i,j) + cmap(i+1,j))./2.0;
			rHighY = (cmap(i,j) + cmap(i,j+1))./2.0;

			G(n,n) = -(rLowX+rHighX+rHighY);
			G(n,nLowX) = rLowX;
			G(n,nHighX) = rHighX;
			G(n,nHighY) = rHighY;


		elseif j == ny
			nLowX = j+(i-2)*ny;
			nHighX = j+i*ny;
			nLowY = (j-1)+(i-1)*ny;

			%Generate values for the resistances as a simple average, considers transitions
			%Between materials
			rLowX = (cmap(i,j) + cmap(i-1,j))./2.0;
			rHighX = (cmap(i,j) + cmap(i+1,j))./2.0;
			rLowY = (cmap(i,j) + cmap(i,j-1))./2.0;

			G(n,n) = -(rLowX+rHighX+rHighY);
			G(n,nLowX) = rLowX;
			G(n,nHighX) = rHighX;
			G(n,nLowY) = rLowY;

		else
			nLowX = j+(i-2)*ny;
			nHighX = j+i*ny;
			nLowY = (j-1)+(i-1)*ny; 
			nHighY = (j+1)+(i-1)*ny;

			rLowX = (cmap(i,j) + cmap(i-1,j))./2.0;
			rHighX = (cmap(i,j) + cmap(i+1,j))./2.0;
			rLowY = (cmap(i,j) + cmap(i,j-1))./2.0;    
			rHighY = (cmap(i,j) + cmap(i,j+1))./2.0; 
            
            G(n,n) = -(rLowX+rHighX+rLowY+rHighY);
			G(n,nLowX) = rLowX;
			G(n,nHighX) = rHighX;
			G(n,nLowY) = rLowY;
			G(n,nHighY) = rHighY;
			
		end

	end
end

solutVect = G\solutVect';

for i = 1:nx
	for j = 1:ny
		n= j+(i-1)*ny;
		solutMat(i,j) = solutVect(n);
	end
end
figure()
surf(solutMat, 'edgecolor', 'none')
rotate3d on;
title("Voltage Across Bottleneck of Dimensions 50 Units x 50 Units", 'Interpreter', 'Latex')
xlabel("X Dimension (Units)", 'Interpreter', 'Latex');
ylabel("Y Dimension (Units)", 'Interpreter', 'Latex');
set(gca, 'FontSize', 15);



%Generate electric field graph given that electric field is gradient of potential
[Ex, Ey] = gradient(solutMat);
figure();
Equiver = quiver(Ex, Ey);
title("Electric Field within Bottleneck of Dimensions 50 Units x 50 Units", 'Interpreter', 'Latex')
xlabel("X Dimension (Units)", 'Interpreter', 'Latex');
ylabel("Y Dimension (Units)", 'Interpreter', 'Latex');
set(gca, 'FontSize', 15);
figure();
Equiverzoom = quiver(Ex, Ey);
title("Electric Field Around High Resistivity Boundary", 'Interpreter', 'Latex')
xlabel("X Dimension (Units)", 'Interpreter', 'Latex');
ylabel("Y Dimension (Units)", 'Interpreter', 'Latex');
set(gca, 'FontSize', 15);
xlim([65 85]);
ylim([110 190]);

%Generate current density J by multiplying E by sigma for each point
figure();
Jx = cmap.*Ex;
Jy = cmap.*Ey;
Equiver = quiver(Jx, Jy);
title("Current Density within Bottleneck of Dimensions 50 Units x 50 Units", 'Interpreter', 'Latex')
xlabel("X Dimension (Units)", 'Interpreter', 'Latex');
ylabel("Y Dimension (Units)", 'Interpreter', 'Latex');
set(gca, 'FontSize', 15);



end