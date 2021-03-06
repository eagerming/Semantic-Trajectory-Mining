%% visulization while reading data directly from raw file
clear;
addpath('..')
addpath('OpenstreetMap_Handler')
dbstop if error;

% 
% %Kaggle porto
% param.inputFile = '../Data/Kaggle/train.csv';
% param.readingNumOfTraj = 2000; %toltalnumber 1710670
% param.img = '../Data/Portugal.png';
% param.imgMap = '../Data/Portugal.png';
% param.imgNetwork = '../Data/Portugal_network_big.png';
% if ~exist('latLong')
%     [latLong,numberOfEffectiveRecords] = kaggle_trajectory_reading(param);
% end
% % param.axisRange = [-8.6986 -8.5455 41.1105 41.2574]; %boundary of Portugal(Kaggle dataset)
% param.axisRange = [-8.7024 -8.5487 41.1347 41.2459]; % for illustration
% param.inChina = false;
% str_save1 = 'Kaggle';
% %===========Load roadmaps==============
% if ~exist('intersection_nodes')
%     load('../Data/Roadmap_Kaggle.mat');
% end



% % Sampling trajectory:
% traN = 10000;
% [index_of_trajectory, pointer_start] = unique(latLong(:,1),'stable');
% numberOfTrajectories = length(index_of_trajectory);
% latLong(pointer_start(traN+1):end,:) = [];


% %T-Drive
% param.inputFile = 'Data/T_Drive';
% param.readingNumOfTraj = 10000;
% param.imgMap = 'Data/beijing1.png';
% param.img = 'figs/Tdrive_raw.bmp';
% param.axisRange = [116.1935 116.5531 39.7513 40.0334 ]; % boundary of Beijing
% param.inChina = true;
% if ~exist('latLong')
% %     [latLong,numberOfEffectiveRecords] = TDrive_trajectory_reading(param);
%     load('Data/Tdrive.mat');
% end
% str_save1 = 'TDrive';
% if ~exist('intersection_nodes')
%     load('../Data/Roadmap_Beijing.mat');
% end
% 
%
% GeoLife
param.inputFile = '../Data/GeoLife';
param.readingNumOfTraj = 100;
param.img = '../Data/beijing1.png';
% param.img = 'figs/GeoLife_raw.bmp';
param.imgMap = '../Data/beijing1.png';
param.axisRange = [116.1935 116.5531 39.7513 40.0334 ]; % boundary of Beijing
param.inChina = false;

if ~exist('latLong')
    [latLong,numberOfEffectiveRecords] = GeoLife_trajectory_reading(param);
%     load('Data/str_save/GeoLife_0p04_Embedding.mat');
end

% latLong  = SplitOneTrajectory2Many(latLong,100);
str_save1 = 'GeoLife';
if ~exist('intersection_nodes')
    load('../Data/Roadmap_Beijing.mat');
end

% % Hurricane
% param.inputFile = 'Data/Hurricane/Hurricane.txt';
% param.readingNumOfTraj = 10000;
% param.imgMap = 'Data/Atlantic.png';
% param.img = 'Data/Atlantic.png';
% param.imgNetwork = 'Data/Hurricane_Network.png';
% param.axisRange = [-113.7077   44.7131    5.2206   74.7249]; % boundary of Atlantic
% param.inChina = false;
% 
% if ~exist('latLong')
%     [latLong,numberOfEffectiveRecords] = Hurricane_trajectory_reading(param);
% end
% str_save1 = 'Hurricane';

% % Migration
% param.inputFile = 'Data/Migration/Swallows.csv';
% param.readingNumOfTraj = 10000;
% param.img = 'Data/SA.png';
% param.imgMap = 'Data/SA.png';
% param.axisRange = [-69.7465  -33.8018  -39.6058   16.8029]; % boundary of Atlantic
% 
% if ~exist('latLong')
%     [latLong,numberOfEffectiveRecords] = Migration_trajectory_reading(param);
% end
% latLong  = SplitOneTrajectory2Many(latLong,3);
% str_save1 = 'Migration';
% param.inChina = false;
% 
% 
% % FourSquare
% % param.inputFile = 'Data/Foursquare-JiHui-Content-Network/CA Dataset/checkin_CA_venues.txt';
% param.inputFile = '../Data/Foursquare-JiHui-Content-Network/CA Dataset/checkin_CA_venues.txt';
% param.readingNumOfTraj = 10000;  
% param.imgMap = '../Data/FourSquare.png';
% param.img = '../Data/FourSquare.png';
% param.imgNetwork = '../Data/FourSquare.png';
% % param.axisRange = [-118.5136   -117.7968    33.5952   34.1743]; % boundary of Atlantic
% param.axisRange = [-118.4251,  -118.1243  33.8288  34.0970];
% param.inChina = false;
% 
% if ~exist('latLong')
%     [latLong,numberOfEffectiveRecords] = Foursquare_trajectory_reading(param);
% end
% str_save1 = 'Foursquare';


% basic clear procedure:
fprintf('number of effective records is [%d].\n original GPS coordinates number is [%d]\n',numberOfEffectiveRecords,size(latLong,1));

disp('=======specify the boundary============');


latLong(latLong(:,3) < param.axisRange(1),:) = [];
latLong(latLong(:,3) > param.axisRange(2),:) = [];
latLong(latLong(:,2) < param.axisRange(3),:) = [];
latLong(latLong(:,2) > param.axisRange(4),:) = [];
latLong(find(isnan(latLong(:,2))),:) = [];
latLong(find(isnan(latLong(:,3))),:) = [];

fprintf('number of effective records is [%d].\n original GPS coordinates number is [%d]\n',numberOfEffectiveRecords,size(latLong,1));

% %% For debug
% temp1 = [254.6522  492.1597   40.5807  283.9862];
% oriscale = [0        1047           0        1073];
% temp2(1) = param.axisRange(1) + (param.axisRange(2) - param.axisRange(1))/oriscale(2) * temp1(1);
% temp2(2) = param.axisRange(1) + (param.axisRange(2) - param.axisRange(1))/oriscale(2) * temp1(2);
% temp2(4) = param.axisRange(4) - (param.axisRange(4) - param.axisRange(3))/oriscale(4) * temp1(3);
% temp2(3) = param.axisRange(4) - (param.axisRange(4) - param.axisRange(3))/oriscale(4) * temp1(4);
% 
% latLong(latLong(:,3) < temp2(1),:) = [];
% latLong(latLong(:,3) > temp2(2),:) = [];
% latLong(latLong(:,2) < temp2(3),:) = [];
% latLong(latLong(:,2) > temp2(4),:) = [];

%% Load Semantic ROI�� Intersection

intersects_threshold = 10;
roundabouts = getRoundabouts(intersects_threshold,connectivity_matrix,intersection_nodes,intersection_node_indices);
roundabouts = roundabouts(:,[2,1]);
param.roundabouts = roundabouts;
param.visualStyle = 'plot';
param.visualRoundabouts = true;
visualization(latLong,param);

%% visualization
 
% 
% param.numberOfVisualization = 30000;
% 
% param.visualStyle = 'plot';
% param.visualRoundabouts = true;
% 
% visualization(latLong,param);

%% Synchronization clustering 

% Specify the number of grid partition.
numberOfPartition = 2^10;        % we partition the map as 1024*1024 by default, 
%which means points locate in the same grid can be deemed as one simple point. 

% Specify the parameters of clustering:
param.Knn = 5;        
param.maxLayer = 100; % this is for manual termination.
param.epsilon = 0.01;



str_save2 = num2str(param.epsilon); % for the data saving usage.
idx_point = strfind(str_save2,'.');
str_save2(idx_point) = 'p';

param.epsilon = param.epsilon * pi/2;
param.max_displacement = 1/numberOfPartition * pi/2; % approximate as 0.001 * pi/2

param.errorTolerance = param.epsilon * 2;
param.syncRoundabouts = true;

disp('=======FastSync...============');
FastSyncResult = Fast_Hierarchical_Synchronization(latLong(:,[2,3]),param);
SPs = [ones(FastSyncResult.numberOfPrototypes,1),FastSyncResult.X];



% 
% param.visualStyle = 'weightedSP';
% param.weight = FastSyncResult.weight;
% visualization(SPs,param);




%% Trace matching from prototype points to original points

% % Specify the tracing indices:
% indices = 1;  p
% isDisplay = true;
% 
% last_layer_indeces = Tracing_particular_point_from_prototype_to_original(FastSyncResult.map_record,indices,latLong(:,[2 3]),FastSyncResult.numberOfPartitions,isDisplay,param);
% 
% SPs = [ones(length(last_layer_indeces),1),...
%     latLong(last_layer_indeces,2),latLong(last_layer_indeces,3)];
% param.visualStyle = 'scatter';
% visualization(SPs,param);


%% Matching original trajectories to new prototype POIs.
% SP_pairs represents the SPs pairs, whose row is [Along, Alat, Blong, BLat]
% SP_pair_indeces is the SPs indeces pair as well as its count presented in
% the trajectory transition, whose row is [A_index, B_index, count].

[latLong_new_representation,latLong_using_prototypes_index,SP_pairs, SP_pair_indeces,transferCount] = matching_to_SPs(latLong,FastSyncResult);
% [SP_pairs,SP_pair_indeces,nodeCount] = removeJumpUsingSPNetwork(SP_pairs,SP_pair_indeces,nodeCount,2);
[nodeCount,nodeCountIdx] = nodeCounting(SP_pairs,SP_pair_indeces);
nodeCount(:,1:2) = FastSyncResult.X;

%%
param.visualStyle = 'heatmap';
param.visualthreshold = 4;
param.SP_pair_indeces = SP_pair_indeces;
param.nodeCount = nodeCount;
param.visualArrow = true;
param.isNodeColor = false;
param.number = false;
visualization(SP_pairs,param);
param.number = false;

% axis([ 100 1351   140        1201]);
% h = gcf;
% h.Position = [483 179 625 530];

% %% Query the poi category of the ROI;
% 
% 
% 
% 
% str_save = strcat('Data/str_save/',str_save1,'_',str_save2,'.mat');
% 
% %% save data for embedding, due to that we need not proceed from scratch.
% str_save = strcat('Data/str_save/',str_save1,'_',str_save2,'.mat');
% save(str_save);
% disp('save successfully!');
% 
% %%
% atleastN = 2;
% [numOfTrajectory,index_of_trajectory,latLong_using_prototypes_index] = GetNumberOfTrajectory(latLong_using_prototypes_index,atleastN);
% 
% %% Trajectory Semantics Retrieval using API 
% ROILevel = 5;
% TraLevel = 5;
% 
% [Category,Rate] = LabelConstructor(SPs, param.inChina);
% 
% % [Category1,Rate1] =  RemoveIndFromRate([1,3,5,9,16,17,18,10,21], Category,Rate);
% LabelSimilarityMat = LabelMatConstructor(Rate,ROILevel);
% 
% 
% TrajRate = TrajectoryLableConstructor(latLong_using_prototypes_index,Rate);
% TrajSimMat = TrajMatSimConstructor(TrajRate, TraLevel );
% % 
% % [ia,ib] = sort(LabelSimilarityMat(206,:),'descend');
% % ia = ia';
% % ib=ib';
% % ia = [ia ib];
% % visualizeTopKSP(FastSyncResult.X, SP_pairs, param,206,ia(2:30,2));
