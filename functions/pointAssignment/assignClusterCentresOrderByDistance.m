function [clusterAssignment] = assignClusterCentresOrderByDistance(data,indClusterCenters)

%%
%%%%%%%%%%%%%% calculate distances %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

distances = pdist(data,'euclidean');

distanceSquare = squareform(distances);

clusterAssignment = zeros(1,length(data));
clusterAssignment(indClusterCenters) = 1:length(indClusterCenters);

while (~isempty(find(clusterAssignment==0)))
    
   distsToAssignedClusters=distanceSquare(clusterAssignment==0,clusterAssignment>0) ;
   iinds=find(clusterAssignment==0);
   jinds=find(clusterAssignment>0);
   dimensions=size(distsToAssignedClusters);
   [y,smallestDistanceInd]=min(distsToAssignedClusters(:));
    [ii,jj]=ind2sub(dimensions,smallestDistanceInd(1));
    clusterAssignment(iinds(ii))=    clusterAssignment(jinds(jj));

end