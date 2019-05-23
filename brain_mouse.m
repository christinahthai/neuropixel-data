ephysroot = '/Users/christinathai/Desktop/R_programming/STA_141A/Project';
% mouse names
mstr = {'Krebs','Waksman','Robbins'};
% start of spontaneous activity in each mouse
tstart = [3811 3633 3323];

% probe location in brain information
% borders tells you region based on depth
% ccfCoords tells you position in microns relative to allen CCF
load(fullfile(ephysroot, 'probeLocations.mat'));
load(fullfile(ephysroot,'probeBorders.mat'));

x = load(fullfile(ephysroot,sprintf('spks/spks%s_Feb18.mat','Krebs')));

% possible brain regions (as strings)
areaLabels = {'FrCtx','FrMoCtx','SomMoCtx','SSCtx','V1','V2','RSP', 'CP','LS','LH','HPF','TH','SC','MB'};

borderLabels = {};
bl = {};
b = {};
for i = 1:8
    borderLabels{i} = struct2cell(probeBorders(1).borders{i});
    [m,n] = size(borderLabels{i});
    bl{i} = (borderLabels{i}(m,1:n));
    temp1 = bl{i}(1,1);
    
    for j = 2:n
       temp = bl{i}(1,j)
       b{i} = [temp1, ' to ', temp];
       temp1 = b{i};
    end
    
    b{i} = strjoin(b{i});

end



%% to plot probe in wire brain, download https://github.com/cortex-lab/allenCCF and npy-matlab
% note that this plot includes every site plotted as a dot - zoom in to see.
addpath(genpath('allenCCF-master'));
addpath(genpath('npy-matlab-master'));



plotBrainGrid([], [], [], 0);
hold all;

co = get(gca, 'ColorOrder');
co(8,:) = [ 0.9350    0.1780    0.3840];
co(1,1) = 0.5;
for imouse = 1
  for pidx = 1:numel(probeLocations(imouse).probe)
      probeColor = co(pidx,:);
      ccfCoords = probeLocations(imouse).probe(pidx).ccfCoords;
   
    % here we divide by 10 to convert to units of voxels (this atlas is 10um
    % voxels, but coordinates are in um) and we swap 3rd with 2nd dimension
    % because Allen atlas dimensions are AP/DV/LR, but the wiremesh brain has
    % DV as Z, the third dimension (better for view/rotation in matlab).
    % So both of these are ultimately quirks of the plotBrainGrid function,
    % not of the ccfCoords data
    
    fig = plot3(ccfCoords(:,1)/10, ccfCoords(:,3)/10, ccfCoords(:,2)/10, '.', 'Color', probeColor,'markersize',4);

   

  end

end

title('\fontsize{20}Mouse Brain')
legend(['grid', b],'Location','southwest')


saveas(fig,'mouse_brain.jpg')

% for q = 1:2:360
%   view(q, 25); drawnow;
% end


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
