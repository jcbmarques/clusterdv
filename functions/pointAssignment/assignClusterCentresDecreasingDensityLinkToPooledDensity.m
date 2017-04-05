function [clusterAssignment] = assignClusterCentresDecreasingDensityLinkToPooledDensity(data,rho,indClusterCenters)


distances = pdist(data,'euclidean');


clusterAssignment = zeros(1,length(data));
clusterAssignment(indClusterCenters) = 1:length(indClusterCenters);

[sortedrho,ii]=sort(rho,'descend');

count=1;
 distanceSquare = squareform(distances);
while (~isempty(find(clusterAssignment==0)))
    
% for n=1:length(rho)
%    distanceSquare(n,rho<=rho(n))=Inf;
%     
% end
if (clusterAssignment(ii(count)) ==0)

   distsToAssignedClusters=distanceSquare(ii(count),clusterAssignment>0) ;
   %iinds=find(clusterAssignment==0);
   jinds=find(clusterAssignment>0);
   %dimensions=size(distsToAssignedClusters);
   [y,smallestDistanceInd]=min(distsToAssignedClusters(:));
   %[ii,jj]=ind2sub(dimensions,smallestDistanceInd(1));
    clusterAssignment(ii(count))=    clusterAssignment(jinds(smallestDistanceInd(1)));
    rho(ii(count))=max(rho(clusterAssignment== clusterAssignment(jinds(smallestDistanceInd(1)))));
    
end
    count=count+1;
    
end