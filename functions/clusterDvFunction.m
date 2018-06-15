
 function [clusterAssignment,indChoosenClusterCenters,clusterCentersSortedIdx,rho,SImeasure,SImeasureRandThreshold,tree] = clusterDvFunction...
     (data,densityType,linedensityMethod,numextra,nsamps,scalingFactor,pointAssignmentMethod,maxNumbOfClusterCenters,clusterNumberDecisionMethod,multirep,kdedens,makeplot)
%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%% test function %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% makeplot = 1;
% clusterNumberDecisionMethod = 'SI_jump';
%  clusterNumberDecisionMethod = 'onion';
%  clusterNumberDecisionMethod = 'simplex';
% % clusterNumberDecisionMethod = 'all_clusters';
% % clusterNumberDecisionMethod = 'square';
% % clusterNumberDecisionMethod = 'dendrogram';
% % 
% kdedens = [];
% densityType = 'local';%type of density estimation: local or localp to normalize dimentions
% linedensityMethod = 'slowPar';%line density method - can be 'slow', 'medium', 'fast, 'slowPar', 'mediumPar', 'fastPar' - par using parallel toolbox
% 
% %resampleMethod = 'onion' ;%methos do make reference distribution - can be 'onion' or 'simplex'
% % resampleMethod = 'simplex' ;%methos do make reference distribution - can be 'onion' or 'simplex'
% 
% numextra = sqrt(length(data));%parameter so set number of lines for the 'medium' mode
% nsamps = 30;%should be large enough - 10 is often enough
% multirep = 100;%times to repeat ref distribution: if zero it will not do any reference distribution
% scallingFactor = 1;%1 no density scalling
% 
% pointAssignmentMethod = 'distance';
% maxNumbOfClusterCenters= 60;%so it does not take too much time
% 
%%
%%%%%%%%%%%%%%%% select parameters according to decision method %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
resampleMethod = 'onion' ;%do onion by default


if strcmp(clusterNumberDecisionMethod, 'SI_jump') == 1
    multirep = 0;%don't do referencces distributions if you choose SI jump
    decisionMethod = 'allClusterCenters';
    
end

if strcmp(clusterNumberDecisionMethod, 'all_clusters') == 1
    multirep = 0;%don't do referencces distributions if you choose all clusters
    decisionMethod = 'allClusterCenters';
end


if strcmp(clusterNumberDecisionMethod, 'square') == 1
    multirep = 0;%don't do referencces distributions if you choose all clusters
    decisionMethod = 'square';
end

if strcmp(clusterNumberDecisionMethod, 'dendrogram') == 1
    multirep = 0;%don't do referencces distributions if you choose all clusters
    decisionMethod = 'dendrogram';

end

if strcmp(clusterNumberDecisionMethod, 'onion') == 1
    
    resampleMethod = 'onion' ;
    if isempty(multirep)
        multirep = 100;
        
        disp('Number of ref was empty while using "onion". Set to 100.')
        
        
    end

end

if strcmp(clusterNumberDecisionMethod, 'simplex') == 1
    resampleMethod = 'simplex' ;
    if isempty(multirep)
        multirep = 100;
        
        disp('Number of ref was empty while using "simplex". Set to 100.')
        
        
    end

end


%%
%%%%%%%%%%%%%%%% run clusterdv %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numbPointsToShow = 100;%so it doe snot show too many points
clusterThreshold = 0.000001;%sometimes is has really small numbers
makeplot1 = 0;



[rho,realRho,delta,SImeasure,SImeasureSorted,kdedens,kdedensRand,maxjump,rhoRand,realRhoRand,...
     deltaRand,SImeasureRand,SImeasureRandSorterAvr,clusterCentersSortedIdx,SImeasureRandSortedAll,...
     diffSImeasure,jumpSImeasure] = ...
     findClusterCentersDensityValley_6(data,kdedens,densityType,linedensityMethod,numextra,nsamps,multirep,...
     numbPointsToShow,clusterThreshold,resampleMethod,scalingFactor,makeplot1);

 
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

if makeplot == 1

makeplot2 = 1;

else
makeplot2 = 0;

end

%maxNumbOfClusterCenters= 60;%so it does not take too much time
%pointAssignmentMethod = 'distance';
lowDensityCutOff = 0;
maxjump = [];
realRho = rho*length(data);

[tree,clusterAssignmentAll,perm] = makeDendrogramByCenterExclusion_4(data,SImeasure,maxNumbOfClusterCenters,rho,realRho,maxjump,pointAssignmentMethod,lowDensityCutOff,clusterCentersSortedIdx,makeplot2);

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


if strcmp(clusterNumberDecisionMethod, 'SI_jump') == 1
numToShow = 50;

if numToShow > size(data,1)
    
    numToShow = size(data,1);
    
end

% jump = diff([1 funnymeasureSorted(1:numToShow)]);
jump = diff([SImeasureSorted(1:numToShow)]);

[~, ind] = min(jump);

if makeplot == 1


figure
subplot(1,3,1)
plot(rho,SImeasure, 'k.')
axis square



subplot(1,3,2)
plot(SImeasureSorted(1:numToShow), 'k.')
axis square



subplot(1,3,3)
plot(jump, 'k-')
hold on
plot(jump, 'ko')
plot(ind,jump(ind), 'ro')
axis square
end


funnymeasureRandThreshold = 0;
indChoosenClusterCenters = clusterCentersSortedIdx(1:ind);

end
%%
%%%%%%%%%%% make point assignment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%pointAssignmentMethod = 'distance';

if makeplot == 1

makeplot3 = 1;

else
makeplot3 = 0;

end


[clusterAssignment] = assignDataPointsAllCases_1(data,indChoosenClusterCenters,rho,maxjump,pointAssignmentMethod,makeplot3);
