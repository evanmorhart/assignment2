function [G] = gGenerate(nx,ny,boundY)
%gGenerate Generates a G matrix to solve finite difference problems
%   gGenerate(nx,ny,boundY)
%   INPUTS
%       nx - number of x elements in map
%       ny - number of y elements in map
%       boundY - specifies if y bound is grounded
%   OUTPUTS
%       G - sparse matrix to solve problem

G = sparse(nx*ny,nx*ny);

for i = 1:nx
    for j = 1:ny
        n=j+(i-1)*ny; 
        if boundY == 1 %No bounded y           
            if i == 1
            elseif i == nx
            elseif j == 0
            elseif j ==ny
            else
            end
        else %Max/min grounded to zero
            if i == 1
            elseif i == nx
            elseif j == 0
            elseif j ==ny
            else
            end
        end
    end
end

end

