
function [clusterAssignment, coreHalo] = assignClusterCentresLinkToDensestClosePointPooledDensityWHalo_3(data,rho,indClusterCenters,maxjump,threshold)

% %define threshold for cluster halo - highest point in the deepest valey...
% clustersep = max(rho) - maxjump(indClusterCenters,indClusterCenters);
% threshold = max(min(clustersep));

% threshold = 0;
distances = pdist(data,'euclidean');


clusterAssignment = zeros(1,length(data));
coreHalo = zeros(1,length(data));
clusterAssignment(indClusterCenters) = 1:length(indClusterCenters);
coreHalo(indClusterCenters) = 1;

%[sortedrho,ii]=sort(rho,'descend');

%count=1;
 distanceSquare = squareform(distances);
 
while (~isempty(find(clusterAssignment == 0)))%goes until all points are assigned
    
    
%%
%%%%%%%%%%%%%% find closest points to each cluster %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for n=1:length(indClusterCenters)%loop through clusters assigns one point per cluster...
    
    %1st get not assigned distances from cluster center
    thisrect = distanceSquare(clusterAssignment==n,clusterAssignment==0) ;
    
    %get row of points of this cluster
    iinds = find(clusterAssignment==n);
    
    %get col of not assigned points
    jinds = find(clusterAssignment==0);
    
    %get closest unassigned point to any point in that cluster 
    [~,smallestDistanceInd] = min(thisrect(:));
    
    %find dimentions of square
    dimensions = size(thisrect);
    
    %transform ind to col and rows
    [ii,jj] = ind2sub(dimensions,smallestDistanceInd(1));
    
    %ind of closest points to the clusters
    thisnextpoint(n) = jinds(jj(1));
    
end

%%
%%% assign highest density point to closest cluster %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %find of the points which has the higher density
    [~,ii] = max(rho(thisnextpoint));


%if (clusterAssignment(ii(count)) ==0)


   %get distances of this point to assigned pointd
   distsToAssignedClusters = distanceSquare(thisnextpoint(ii),clusterAssignment > 0) ;
   %iinds=find(clusterAssignment==0);
   
   %get inds of assignbed points
   jinds = find(clusterAssignment > 0);
   %dimensions=size(distsToAssignedClusters);
   
   %find closest point
   [y,smallestDistanceInd] = min(distsToAssignedClusters(:));
   %[ii,jj]=ind2sub(dimensions,smallestDistanceInd(1));
   
   %assign this point to the same cluster as the closest distance already assigned point
   clusterAssignment(thisnextpoint(ii)) = clusterAssignment(jinds(smallestDistanceInd(1)));
    
   %%
   %create halo
   if (rho(thisnextpoint(ii)) > threshold)
        
       coreHalo(thisnextpoint(ii)) = 1; 
       
   end
    
    %rho(ii(count))=max(rho(clusterAssignment== clusterAssignment(jinds(smallestDistanceInd(1)))));
    
%    count=count+1;
    
end