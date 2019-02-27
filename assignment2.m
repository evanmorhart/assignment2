% addpath(strcat(fileparts(mfilename('fullpath')), '\code'));
% format compact


% noResist(150,100,1,500);
% pause(0.01);
% fprintf("Unbound Y Finished \n")

% fprintf("Started Grounded Y \n")
% noResist(150,100,2,500);
% pause(0.01)
% fprintf("Grounded Y Finished \n")

% fprintf("Starting high resist graphing")
% highResist(10E-5, 1, 300, 200, 50, 50, 'graph')
% pause(0.01)
% fprintf("Finished High Resist Graphing \n")

% fprintf("Starting meshing investigation \n")


% %Retain the same 2/3 ratio of y points to x points for all current calculations
% nxSpace = linspace(25, 300, 20);
% nySpace = 2.*nxSpace./3;

% meshCurrent = zeros(length(nxSpace),1);


% for i = 1:length(nxSpace)
% 	fprintf("Meshing %i of %i \n", i, length(nxSpace));
% 	%Calculate ratio of bottleneck size to mesh size, assuming the same 1/6 ratio as first calc
% 	bottledim = uint8(nxSpace(i)./6);

% 	meshCurrent(i) = highResist(10E-5, 1, round(nxSpace(i)), round(nySpace(i)), round(bottledim), round(bottledim), 'no');
% end

% figure()
% plot(nxSpace, meshCurrent)
% title("Current within Bottleneck of Dimensions 50 Units x 50 Units", 'Interpreter', 'Latex')
% xlabel("Number of Elements in X Dimension of Vector", 'Interpreter', 'Latex');
% ylabel("Calculated Current", 'Interpreter', 'Latex');
% set(gca, 'FontSize', 15);

% fprintf("Finsihed Meshing \n");
% fprintf("Starting Conduction Investigation \n")

% conductSpace = linspace(10E-5, 1, 20);
% conductCurrent = zeros(length(conductSpace),1);
% figure()
% for i = 1:length(conductSpace)
% 	fprintf("Conduction %i of %i, Value: %f \n", i, length(conductSpace), conductSpace(i));

% 	conductCurrent(i) = highResist(10E-5, conductSpace(i), 300, 200, 50, 50, 'noGraph');
% 	plot(conductSpace, conductCurrent)
% 	pause(0.01);
% end



widthSpace = linspace(10, 250, 20);
widthCurrent = zeros(length(widthSpace),1);
figure()
for i = 1:length(widthSpace)
	fprintf("Spacing %i of %i, Value: %f \n", i, length(widthSpace), widthSpace(i));

	widthCurrent(i) = highResist(10E-5, 1, 300, 200, 50, round(widthSpace(i)), 'noGraph');
	plot(widthSpace, widthCurrent)
	pause(0.01);
end



title("Current within Bottleneck of Varying Dimensions", 'Interpreter', 'Latex')
xlabel("Width of Bottleneck in Rectangular Region", 'Interpreter', 'Latex');
ylabel("Calculated Current", 'Interpreter', 'Latex');
set(gca, 'FontSize', 15);

fprintf("Finished");