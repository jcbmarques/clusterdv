


%%
%%%%%%%%%%%%% what this function does %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1) assigns data points to clusters - closest points to density center in order


 function [clusterAssignment] = assignPointsToClustersDistanceWHalo_2(data,indClusterCenters,rho,maxjump,makeplot)


%%
% %%%%%%%%%%%%%%%%%% define halo threshold %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  clustersep=max(rho)-maxjump(indClusterCenters,indClusterCenters);
% threshold=max(min(clustersep));
%  
%%
%%%%%%%%%%%%%%%% calculate distances %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


distances = pdist(data,'euclidean');

distanceSquare = squareform(distances);


%%



clusterAssignment = zeros(1,length(data));
clusterAssignment(indClusterCenters) = 1:length(indClusterCenters);

%sort rho
[rhoSorted,rhoIdx] = sort(rho, 'descend');

clusterAssignmentSorted = clusterAssignment(rhoIdx);

% figure
% numbClusters = length(indClusterCenters);
% % subplot(1,2,1)
% plot(data(:,1),data(:,2), 'k.')
% hold on


for n = 1  : length(rhoSorted)%loop through every point by density
    
     if clusterAssignment(rhoIdx(n)) == 0%avoid already assigned points
         
     %get distances of this point
     thisPointDistances = distanceSquare(rhoIdx(n),:);  
     
     %order distances by density
     thisPointDistancesSorted = thisPointDistances(rhoIdx);
     
     %find points of higher density
     thisPointDistancesSortedHigherDensity = thisPointDistancesSorted(1:(n-1));
     
     %find points that were already assigned
     indAssignedPoints = find(clusterAssignmentSorted ~= 0);
      
     
     %of assigned points find the point of higher density !!!!
     indAssignedPointsWithHighDensity = find(indAssignedPoints < n);
     
     %find closest point
     [~, indMin] = min(thisPointDistancesSorted(indAssignedPointsWithHighDensity));
     
     %get point val
     pointVal = clusterAssignmentSorted(indMin);
     
     %assign point
     clusterAssignmentSorted(n) = pointVal;      
         
     %%
%      %%%%%%%%%%%%%% make plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       
%      %unsort clusterAssingment
% unsorted = 1:length(clusterAssignmentSorted);
% newInd(rhoIdx) = unsorted;
% 
% clusterAssignment = clusterAssignmentSorted(newInd);
%      
%   for n = 1 :  numbClusters% loop through each cluster
%      hold on 
% 
%       
%       %cluster core
%       indThisCluster = find(clusterAssignment == n);
%       
% %       plot(data(indThisCluster,1),data(indThisCluster,2), 'o','MarkerFaceColor', col(n,:),'MarkerEdgeColor', 'k','MarkerSize',10,'lineWidth',3)
%       plot(data(indThisCluster,1),data(indThisCluster,2), 'o','color', col(n,:))%,'MarkerEdgeColor', 'k','MarkerSize',10,'lineWidth',3)
% 
%      plot(data(indClusterCenters(n),1),data(indClusterCenters(n),2), 'o','MarkerFaceColor', col(n,:),'MarkerEdgeColor', 'k','MarkerSize',10,'lineWidth',3)
% 
%       
% box off
% title(numbClusters)
%       pause(0.1)
% %       draw now
%  end

    
         
     end
    
    
 

    
end

%unsort clusterAssingment
unsorted = 1:length(clusterAssignmentSorted);
newInd(rhoIdx) = unsorted;

clusterAssignment = clusterAssignmentSorted(newInd);


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% make plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numbClusters = length(indClusterCenters);


if makeplot == 1
    
figure
subplot(1,2,1)
plot(data(:,1),data(:,2), 'k.')
hold on


axis square
box off
 
 col =  jet(numbClusters);
 subplot(1,2,2)
 
 for n = 1 :  numbClusters% loop through each cluster
     hold on 

      
      %cluster core
      indThisCluster = find(clusterAssignment == n);
      
%       plot(data(indThisCluster,1),data(indThisCluster,2), 'o','MarkerFaceColor', col(n,:),'MarkerEdgeColor', 'k','MarkerSize',10,'lineWidth',3)
      plot(data(indThisCluster,1),data(indThisCluster,2), '.','color', col(n,:))%,'MarkerEdgeColor', 'k','MarkerSize',10,'lineWidth',3)

     plot(data(indClusterCenters(n),1),data(indClusterCenters(n),2), 'o','MarkerFaceColor', col(n,:),'MarkerEdgeColor', 'k','MarkerSize',10,'lineWidth',3)

      
box off
title(numbClusters)
      
 end

 
 
 axis square
 hold off
 
 
end  
