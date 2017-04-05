clear all
close all


%%%%%%%%%%%%%%%%%%%%%%%% read me %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This package includes the Matlab implementation of density valley clustering 
%(clusterdv). This program is free software. Clusterdv is a density based 
%clustering method and to estimate local densities uses the Kernel Density 
% Estimate (kde) Matlab-based toolbox written by Alex Ihler and Mike Mandel 
%(freely available in http://www.ics.uci.edu/~ihler/code/kde.html). 
% The rest of the functions and code were writen by Joao Marques and 
% Michael Orger. The authors may be contacted via email 
% at:jcbmarques@gmail.com and michael.orger@neuro.fchampalimaud.org.

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Instructions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%1) Add folder and sub folders of clusterdv package to Matlab 
%2) The user may decide the decision method to choose number of cluster
%centers by changing the variable 'decisionMethod'
%3) By running script a user interface appears. The user should pick a data
%set in the correct format
%4) cluster assignment is saved in 'clusterAssignment' and the index of the
%cluster centers are saved in 'indChoosenClusterCenters'



%%
%%%%%%%%%%%%%%%%%%%%pick data file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%pick main folder where data set is
[FileName,PathName] =  uigetfile('*.*');

load(strcat(PathName,FileName));

%%
% %%%%%%%%%%%%%% defien number of workers to use %%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %uncomment if you have matlab parallel toolbox
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
densityType = 'local';%type of density estimation: local or localp (normalises dimensions)
linedensityMethod = 'slowPar';%line density method - can be 'slow', 'medium', 'fast, 'slowPar', 'mediumPar', 'fastPar' - par using parallel toolbox
resampleMethod = 'onion' ;%methods do make reference distribution - can be 'onion' or 'simplex'

numextra = sqrt(length(data));%parameter to set number of lines for the 'medium' or 'mediumPar' mode
nsamps = 30;%should be large enough - 10 is often enough
multirep = 10;%times to repeat ref distribution: if 0 it will not do any reference distribution
makeplot = 0;
numbPointsToShow = 100;%so it does not show too many points
clusterThreshold = 0.000001;%sometimes is has really small numbers
scalingFactor = 1;%1 no density scaling


[rho,realRho,delta,SImeasure,SImeasureSorted,kdedens,kdedensRand,maxjump,rhoRand,realRhoRand,...
     deltaRand,SImeasureRand,SImeasureRandSorterAvr,clusterCentersSortedIdx,SImeasureRandSortedAll,...
     diffSImeasure,jumpSImeasure] = ...
     findClusterCentersDensityValley_6(data,kdedens,densityType,linedensityMethod,numextra,nsamps,multirep,...
     numbPointsToShow,clusterThreshold,resampleMethod,scalingFactor,makeplot);

 
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
maxNumbOfClusterCenters= 15;%It can be any larger number that the number of clusters. It saves time to put a number close to the number of clusters. 
pointAssignmentMethod = 'distance';
lowDensityCutOff = 0;
maxjump = [];
realRho = rho*length(data);

[tree,clusterAssignmentAll,perm] = makeDendrogramByCenterExclusion_4(data,SImeasure,maxNumbOfClusterCenters,rho,realRho,maxjump,pointAssignmentMethod,lowDensityCutOff,clusterCentersSortedIdx,makePlot2);

%%
%%%%%%%%%%%%% decide correct number of cluster centers %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
decisionMethod = 'allClusterCenters';
%'allClusterCenters' defines cluster center by threshold of ref distribution. 
%'square' user can make a square to choose cluster centers. 
%'dendrogram' user clicks at the level of the dendrogram to choose cluster centers
%'allExcludeOutliers' picks all cluster centers that have greater density than 'SImeasureRandThreshold'

[indChoosenClusterCenters] = decideClusterCentersAll_3(data,tree,clusterCentersSortedIdx,realRho,SImeasure,SImeasureRandThreshold,decisionMethod);

%%
%%%%%%%%%%% makes point assignment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pointAssignmentMethod = 'distance';

makeplot = 1;
[clusterAssignment] = assignDataPointsAllCases_1(data,indChoosenClusterCenters,rho,maxjump,pointAssignmentMethod,makeplot);
