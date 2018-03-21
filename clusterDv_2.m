clear all
close all


%%%%%%%%%%%%%%%%%%%%%%%% read me %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this packege uses the Kernel density Estimate Matlab-based toolbox developed by 
% Alexander Ihler (http://www.ics.uci.edu/~ihler/code/kde.html). 

%%
%%%%%%%%%%%%%% what this does %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1) loads dataset - it has to be in correct mat file format
%2) applies density valley clustering

%%
%%%%%%%%%%%%%%%%%%%%pick data file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%pick main folder where data set is
[FileName,PathName] =  uigetfile('*.*');

load(strcat(PathName,FileName));




%%
% %%%%%%%%%%%%%% defien number of workers to use %%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %if have matlab parallel toolbox
% %matlabpool('close');
% 
% %close matlabpool if it is already opened
% if matlabpool('size') ~= 0 % checking to see if my pool is already open
%     
%     matlabpool close
% %     matlabpool open numberOfWorkers
%     
%     
% end
% 
% %start matlab pool with number of corrers
% matlabpool open 4


%%
%%%%%%%%%%%%%%%%%% apply clusterDv %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

kdedens = [];
densityType = 'local';%type of density estimation: local or localp to normalize dimentions
linedensityMethod = 'slow';%line density method - can be 'slow', 'medium', 'fast, 'slowPar', 'mediumPar', 'fastPar' - par using parallel toolbox
resampleMethod = 'onion' ;%methos do make reference distribution - can be 'onion' or 'simplex'
% resampleMethod = 'simplex' ;%methos do make reference distribution - can be 'onion' or 'simplex'

numextra = sqrt(length(data));%parameter so set number of lines for the 'medium' mode
nsamps = 30;%should be large enough - 10 is often enough
multirep = 0;%times to repeat ref distribution: if zero it will not do any reference distribution
makeplot = 0;
numbPointsToShow = 100;%so it doe snot show too many points
clusterThreshold = 0.000001;%sometimes is has really small numbers
scallingFactor = 1;%1 no density scalling


[rho,realRho,delta,SImeasure,SImeasureSorted,kdedens,kdedensRand,maxjump,rhoRand,realRhoRand,...
     deltaRand,SImeasureRand,SImeasureRandSorterAvr,clusterCentersSortedIdx,SImeasureRandSortedAll,...
     diffSImeasure,jumpSImeasure] = ...
     findClusterCentersDensityValley_6(data,kdedens,densityType,linedensityMethod,numextra,nsamps,multirep,...
     numbPointsToShow,clusterThreshold,resampleMethod,scallingFactor,makeplot);

 
 %%
%%%%%%%%%%%%%%% calculate threshold %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SImeasureRandThreshold = prctile(SImeasureRandSortedAll(:,2),99);

%  [val, ind] = min(diff(SImeasureSorted(1:100)));
%     
%     if ind == 1
%        ind = 2 ;
%     end
%     
%     SImeasureBigDiffThreshold = SImeasureSorted(ind);
    
%%
%%%%%%%%%%%%%% do dendrogram %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

makePlot2 = 1;
maxNumbOfClusterCenters= 15;%so it does not take too much time
pointAssignmentMethod = 'distance';
lowDensityCutOff = 0;
maxjump = [];
realRho = rho*length(data);

[tree,clusterAssignmentAll,perm] = makeDendrogramByCenterExclusion_4(data,SImeasure,maxNumbOfClusterCenters,rho,realRho,maxjump,pointAssignmentMethod,lowDensityCutOff,clusterCentersSortedIdx,makePlot2);

%%
%%%%%%%%%%%%% decide correct number of cluster centers %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
decisionMethod = 'allClusterCenters';%'allClusterCenters' defines cluster center by threshold of ref distribution. 'square' user can make a square to 
%choose cluster centers. 'dendrogram' user clicks at the level of the
%dendrogram to choose cluster centers

[indChoosenClusterCenters] = decideClusterCentersAll_3(data,tree,clusterCentersSortedIdx,realRho,SImeasure,SImeasureRandThreshold,decisionMethod);

%%
%%%%%%%%%%%%%%% calcualte SI jump %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%uncomment to choose clusters by SI jump 


numToShow = 50;

if numToShow > size(data,1)
    numToShow = size(data,1);
    
end

figure
subplot(1,3,1)
plot(rho,SImeasure, 'k.')
axis square



subplot(1,3,2)
plot(SImeasureSorted(1:numToShow), 'k.')
axis square

% jump = diff([1 funnymeasureSorted(1:numToShow)]);
jump = diff([SImeasureSorted(1:numToShow)]);

[~, ind] = min(jump);

subplot(1,3,3)
plot(jump, 'k-')
hold on
plot(jump, 'ko')
plot(ind,jump(ind), 'ro')
axis square

funnymeasureRandThreshold = 0;
indChoosenClusterCenters = clusterCentersSortedIdx(1:ind);


%%
%%%%%%%%%%% make point assignment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pointAssignmentMethod = 'distance';

makeplot = 1;
[clusterAssignment] = assignDataPointsAllCases_1(data,indChoosenClusterCenters,rho,maxjump,pointAssignmentMethod,makeplot);
