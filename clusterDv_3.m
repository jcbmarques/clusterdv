clear all
close all


%%%%%%%%%%%%%%%%%%%%%%%% read me %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this package uses the Kernel density Estimate Matlab-based toolbox developed by 
% Alexander Ihler (http://www.ics.uci.edu/~ihler/code/kde.html). 

%%
%%%%%%%%%%%%%% what this does %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1) loads data set - it has to be in correct mat file format
%2) applies density valley clustering

%%
%%%%%%%%%%%%%%%%%%%%pick data file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Pick main file with data set.
%mat file with variable "data" inside, rows are data points and columns n dimensions of the data
[FileName,PathName] =  uigetfile('*.*');

load(strcat(PathName,FileName));


%%
%%%%%%%%%%%%%%%%%% clusterDv inputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Select method to calculate number of clusters
clustNumDecision = 'SI_jump';%it may be: 'SI_jump','onion','simplex', 'all_clusters','square', or 'dendrogram'. For Beep20 data set you should select 'simplex' 

%Select density estimation method
densityType = 'local';%type of density estimation: select 'local' or 'localp' (normalise dimensions)

%Select method to estimate the density lines.
lineDensityMethod = 'slow';%line density method - can be 'slow', 'medium', 'fast, 'slowPar', 'mediumPar', 'fastPar' - "par" methods uses Matlab parallel toolbox

%parameter that defines the number of edges uses in the 'medium' or 'mediumPar' 
numextra = sqrt(length(data));%it does not do anything if another line density method is selected

%parameter that defines the number of divisions used to calculate line density lines 
nsamps = 30;%should be large enough - 10 is often enough. We used 30 for Beep20, exclamation mark 1 and exclamation mark 2 data sets

%select number of repetitions to do reference distribution.
multirep = 100;%if zero it will not do any reference distribution. If a decision method that does not use reference distribution it becomes 0.

%factor used to scale bandwidths used to calculate densities
scalingFactor = 1;%it should be 1, no dendity scalling applied. 

%method used to assign data points
pointAssignmentMethod = 'distance';

%number of clusters used to calculate dendrogram.
maxNumbOfClusterCenters = 20;%Calculating the dendrogram is computationally costly. The user should a select a number larger than the number of clusters that exist in the data set.

%kde density object
kdedens = [];% in case kde object was already calculated insert it here. If left empty clusterDvFunction will calculate it again.

%Show plots with clustering result
makeplot = 1;%clustering solution, dendrogram, and SI jump in the case this method is selected

%%
%%%%%%%%%%%%%%%%%%%%% Run clusterDv %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[clusterAssignment,indChoosenClusterCenters,clusterCentersSortedIdx,rho,SImeasure,SImeasureRandThreshold,tree] = clusterDvFunction...
    (data,densityType,lineDensityMethod,numextra,nsamps,scalingFactor,pointAssignmentMethod,maxNumbOfClusterCenters,clustNumDecision,multirep,kdedens,makeplot);


%%
%%%%%%%%%%%%%%%%%%% outputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%clusterAssignment - vector with cluster assignments. Each number is a different cluster.	
%indChoosenClusterCenters - index of cluster centers selected by clusterDv.
%clusterCentersSortedIdx  - index of all points that have SI larger than 0
%rho - point density.
%SImeasure - separability index for each point.
%SImeasureRandThreshold - threshold defined by method that selects cluster centers.
%trer - SI dendrogram.




