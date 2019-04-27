% The following script is based on ephysLoad.m
% Downloaded from https://janelia.figshare.com/articles/Eight-probe_Neuropixels_recordings_during_spontaneous_behaviors/7739750
% The original data sets are not on Canvas, but you can download them from
% the above link
ephysroot = './Data/';
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

% how many nSV
nSV=50; % first 50 SVs

% which mouse
imouse=1;


mouse_name = mstr{imouse};

% load spikes
load(fullfile(ephysroot, sprintf('spks/spks%s_Feb18.mat',mouse_name)));
% spks(k).st = spike times (in seconds)
% spks(k).clu = cluster identity of each spike in st (which neuron does spike belong to)
% spks(k).Wheights = height of each cluster on the probe

%   % load behavior file
beh = load(fullfile(ephysroot, sprintf('faces/%s_face_proc.mat',mouse_name)));
% movie of mouse face during recording was dimensionality reduced using SVD
% beh.motionSVD = timepoints x components
% beh.motionMask = pixels x pixels x components
% beh.times = times of behavioral frames (in seconds) in same timeframe as spikes
motSVD = beh.motionSVD;
tVid = beh.times; % times of movie frames in spike reference frame

%% extract spike times and create a matrix neurons x time
stall = zeros(5e3,5500,'uint8');
ij = 0;
maxt=0;
Wh = [];
iprobe=[];
brainLoc=[];
srate = 30; % sampling rate in Hz (how much to bin matrix)
% loop over probes
for k = 1:numel(spks)
    clu = spks(k).clu; % cluster ids
    st  = spks(k).st; % spike times in seconds
    st = round(st*srate); % spike times in 30Hz
    
    % transform spike times into a matrix
    % any duplicates of spike times are added together
    S = sparse(st, clu, ones(1, numel(clu)));
    S = uint8(full(S))';
    % there might be missing numbers (bad spike clusters)
    S = S(sort(unique(clu)),:);
    
    % add these to the big matrix with all probes
    stall(ij+[1:size(S,1)],1:size(S,2)) = S;
    ij = ij + size(S,1);
    maxt = max(maxt, size(S,2));
    
    % height of clusters on the probe
    % we will use these to determine the brain area
    whp = spks(k).Wheights(sort(unique(clu)));
    
    % borders of brain areas wrt the probe
    lowerBorder = probeLocations(imouse).probe(k).borders.lowerBorder;
    upperBorder = probeLocations(imouse).probe(k).borders.upperBorder;
    acronym     = probeLocations(imouse).probe(k).borders.acronym;
    loc = zeros(numel(whp),1);
    % determine brain area for each cluster based on whp
    for j = 1:numel(acronym)
        whichArea = find(strcmp(areaLabels, acronym{j}));
        loc(whp >= lowerBorder(j) & whp < upperBorder(j)) = whichArea;
    end
    
    % concatenate for all probes
    Wh = [Wh; whp];
    brainLoc = [brainLoc; loc];
    iprobe=[iprobe; k * ones(size(S,1),1)];
end
%%
stall = stall(1:ij, 1:maxt);

% only use spontaneous time frames
tspont = tstart(imouse)*srate : min(floor(tVid(end)*srate), size(stall,2)-4);
stall = stall(:,tspont);
tspont = tspont / srate; % put back in seconds

% to put the behavioral data into the spike frames (no time delays)
x = interp1(tVid, motSVD, tspont);
motSVD = x(:,1:nSV);
motionMask=beh.motionMask(:,:,1:nSV);
avgframe=beh.avgframe;
stall=double(stall);

if imouse==1 %% Krebs
    uniqueLoc=unique(brainLoc);
    
    stall_FrMoCtx=stall(find(brainLoc==2),:);
    stall_SomMoCtx=stall(find(brainLoc==3),:);
    stall_V1=stall(find(brainLoc==5),:);
    stall_CP=stall(find(brainLoc==8),:);
    stall_LS=stall(find(brainLoc==9),:);
    stall_HPF=stall(find(brainLoc==11),:);
    stall_TH=stall(find(brainLoc==12),:);
    stall_SC=stall(find(brainLoc==13),:);
    stall_MB=stall(find(brainLoc==14),:);
    
    faceSVD=motSVD';
    save('Krebs_reduced.mat','faceSVD','motionMask','avgframe','stall_FrMoCtx','stall_SomMoCtx',...
        'stall_V1','stall_CP','stall_LS','stall_HPF','stall_TH','stall_SC','stall_MB');
    
elseif imouse==2 %% Waksman
    uniqueLoc=unique(brainLoc);
    
    stall_FrCtx=stall(find(brainLoc==1),:);
    stall_FrMoCtx=stall(find(brainLoc==2),:);
    stall_SomMoCtx=stall(find(brainLoc==3),:);
    stall_SSCtx=stall(find(brainLoc==4),:);
    stall_V1=stall(find(brainLoc==5),:);
    stall_V2=stall(find(brainLoc==6),:);
    stall_RSP=stall(find(brainLoc==7),:);
    stall_LS=stall(find(brainLoc==9),:);
    stall_HPF=stall(find(brainLoc==11),:);
    stall_TH=stall(find(brainLoc==12),:);
    stall_SC=stall(find(brainLoc==13),:);
    stall_MB=stall(find(brainLoc==14),:);
    
    faceSVD=motSVD';
    save('Waksman_reduced.mat','faceSVD','motionMask','avgframe','stall_FrCtx','stall_FrMoCtx',...
        'stall_SomMoCtx','stall_SSCtx','stall_V1','stall_V2','stall_RSP',...
        'stall_LS','stall_HPF','stall_TH','stall_SC','stall_MB');
    
elseif imouse==3 %% Robbins
    uniqueLoc=unique(brainLoc);
    
    stall_FrMoCtx=stall(find(brainLoc==2),:);
    stall_SomMoCtx=stall(find(brainLoc==3),:);
    stall_RSP=stall(find(brainLoc==7),:);
    stall_CP=stall(find(brainLoc==8),:);
    stall_LS=stall(find(brainLoc==9),:);
    stall_LH=stall(find(brainLoc==10),:);
    stall_HPF=stall(find(brainLoc==11),:);
    stall_TH=stall(find(brainLoc==12),:);
    
    faceSVD=motSVD';
    save('Robbins_reduced.mat','faceSVD','motionMask','avgframe','stall_FrMoCtx',...
        'stall_SomMoCtx','stall_RSP','stall_CP',...
        'stall_LS','stall_LH','stall_HPF','stall_TH');
end