function [clusterAssignment] = assignClusterCentresOrderByDensityUseMindip(data,rho,mindip,indClusterCenters)

distanceSquare = mindip;

clusterAssignment = zeros(1,length(data));
clusterAssignment(indClusterCenters) = 1:length(indClusterCenters);


for n=1:length(rho)
   distanceSquare(n,rho<=rho(n))=Inf;
    
end

while (~isempty(find(clusterAssignment==0)))
   distsToAssignedClusters=distanceSquare(clusterAssignment==0,clusterAssignment>0) ;
   iinds=find(clusterAssignment==0);
   jinds=find(clusterAssignment>0);
   dimensions=size(distsToAssignedClusters);
   [y,smallestDistanceInd]=min(distsToAssignedClusters(:));
    [ii,jj]=ind2sub(dimensions,smallestDistanceInd(1));
    clusterAssignment(iinds(ii))=    clusterAssignment(jinds(jj));

end