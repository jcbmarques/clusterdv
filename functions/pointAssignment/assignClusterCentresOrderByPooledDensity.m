function [clusterAssignment] = assignClusterCentresOrderByPooledDensity(data,rho,indClusterCenters)


distances = pdist(data,'euclidean');


clusterAssignment = zeros(1,length(data));
clusterAssignment(indClusterCenters) = 1:length(indClusterCenters);



while (~isempty(find(clusterAssignment==0)))
    
distanceSquare = squareform(distances);
for n=1:length(rho)
   distanceSquare(n,rho<=rho(n))=Inf;
    
end

   distsToAssignedClusters=distanceSquare(clusterAssignment==0,clusterAssignment>0) ;
   iinds=find(clusterAssignment==0);
   jinds=find(clusterAssignment>0);
   dimensions=size(distsToAssignedClusters);
   [y,smallestDistanceInd]=min(distsToAssignedClusters(:));
    [ii,jj]=ind2sub(dimensions,smallestDistanceInd(1));
    clusterAssignment(iinds(ii))=    clusterAssignment(jinds(jj));
    rho(iinds(ii))=max(rho(clusterAssignment== clusterAssignment(jinds(jj))));
end