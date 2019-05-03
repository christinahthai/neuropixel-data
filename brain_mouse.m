load('probeLocations.mat')

v = struct2cell(probeLocations);
krebs = v(:,:,1);
celldisp(krebs);
krebs{1}(1,2)

for i = 1:8
krebs{1}(i).borders
end



ephysroot = '/Users/christinathai/Desktop/R_programming/STA_141A/Project'
% mouse names
mstr = {'Krebs','Waksman','Robbins'};
% start of spontaneous activity in each mouse
tstart = [3811 3633 3323];

% probe location in brain information
% borders tells you region based on depth
% ccfCoords tells you position in microns relative to allen CCF
load(fullfile(ephysroot, 'probeLocations.mat'));

% possible brain regions (as strings)
areaLabels = {'FrCtx','FrMoCtx','SomMoCtx','SSCtx','V1','V2','RSP',...
'CP','LS','LH','HPF','TH','SC','MB'};

%% to plot probe in wire brain, download https://github.com/cortex-lab/allenCCF and npy-matlab
% note that this plot includes every site plotted as a dot - zoom in to see.
addpath(genpath('allenCCF-master'));
addpath(genpath('npy-matlab-master'));
plotBrainGrid([], [], [], 0);
hold all;
co = get(gca, 'ColorOrder');
for imouse = 1
  probeColor = co(imouse,:);
  for pidx = 1:numel(probeLocations(imouse).probe)
    ccfCoords = probeLocations(imouse).probe(pidx).ccfCoords;

    % here we divide by 10 to convert to units of voxels (this atlas is 10um
    % voxels, but coordinates are in um) and we swap 3rd with 2nd dimension
    % because Allen atlas dimensions are AP/DV/LR, but the wiremesh brain has
    % DV as Z, the third dimension (better for view/rotation in matlab).
    % So both of these are ultimately quirks of the plotBrainGrid function,
    % not of the ccfCoords data
    fig = plot3(ccfCoords(:,1)/10, ccfCoords(:,3)/10, ccfCoords(:,2)/10, '.', 'Color', probeColor,'markersize',4)
    title('Mouse Brain')
  end
end
saveas(fig,'mouse_brain.png')
% for q = 1:2:360
%   view(q, 25); drawnow;
% end
