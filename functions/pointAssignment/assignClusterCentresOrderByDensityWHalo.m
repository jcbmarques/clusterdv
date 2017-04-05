function [clusterAssignment,coreHalo] = assignClusterCentresOrderByDensityWHalo(data,rho,indClusterCenters,maxjump)

%%
%%%%%%%%%%%%%%%%%% define halo threshold %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 clustersep=max(rho)-maxjump(indClusterCenters,indClusterCenters);
threshold=max(min(clustersep));
 
%%

distances = pdist(data,'euclidean');

distanceSquare = squareform(distances);

clusterAssignment = zeros(1,length(data));
coreHalo = zeros(1,length(data));
clusterAssignment(indClusterCenters) = 1:length(indClusterCenters);
coreHalo(indClusterCenters) = 1;

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

    if (rho(iinds(ii))>threshold)
       coreHalo(iinds(ii))=1; 
    end
    
    
end