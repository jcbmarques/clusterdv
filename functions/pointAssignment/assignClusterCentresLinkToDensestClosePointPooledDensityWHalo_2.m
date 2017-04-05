
function [clusterAssignment, coreHalo] = assignClusterCentresLinkToDensestClosePointPooledDensityWHalo_2(data,rho,indClusterCenters,maxjump)

%define threshold for cluster halo - highest point in the deepest valey...
clustersep = max(rho) - maxjump(indClusterCenters,indClusterCenters);
threshold = max(min(clustersep));

% threshold = 0;
distances = pdist(data,'euclidean');


clusterAssignment = zeros(1,length(data));
coreHalo = zeros(1,length(data));
clusterAssignment(indClusterCenters) = 1:length(indClusterCenters);
coreHalo(indClusterCenters) = 1;

%[sortedrho,ii]=sort(rho,'descend');

%count=1;
 distanceSquare = squareform(distances);
while (~isempty(find(clusterAssignment==0)))%goes until all points are assigned
    
for n=1:length(indClusterCenters)%loop through clusters
    
    %1st get distances from cluster center
    thisrect = distanceSquare(clusterAssignment==n,clusterAssignment==0) ;
    
    %get coordenats
    iinds = find(clusterAssignment==n);
    jinds = find(clusterAssignment==0);
    
    %get closest unassigned point to any point in that cluster 
    [~,smallestDistanceInd] = min(thisrect(:));
    
    
    dimensions = size(thisrect);
    
    %transform ind to col and rows
    [ii,jj] = ind2sub(dimensions,smallestDistanceInd(1));
    
    thisnextpoint(n) = jinds(jj(1));
    
end
[~,ii]=max(rho(thisnextpoint));


%if (clusterAssignment(ii(count)) ==0)

   distsToAssignedClusters=distanceSquare(thisnextpoint(ii),clusterAssignment>0) ;
   %iinds=find(clusterAssignment==0);
   jinds=find(clusterAssignment>0);
   %dimensions=size(distsToAssignedClusters);
   [y,smallestDistanceInd]=min(distsToAssignedClusters(:));
   %[ii,jj]=ind2sub(dimensions,smallestDistanceInd(1));
    clusterAssignment(thisnextpoint(ii))=    clusterAssignment(jinds(smallestDistanceInd(1)));
    if (rho(thisnextpoint(ii))>threshold)
       coreHalo(thisnextpoint(ii))=1; 
    end
    %rho(ii(count))=max(rho(clusterAssignment== clusterAssignment(jinds(smallestDistanceInd(1)))));
    
%    count=count+1;
    
end