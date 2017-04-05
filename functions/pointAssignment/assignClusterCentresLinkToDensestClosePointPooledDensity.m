function [clusterAssignment] = assignClusterCentresLinkToDensestClosePointPooledDensity(data,rho,indClusterCenters)


distances = pdist(data,'euclidean');


clusterAssignment = zeros(1,length(data));
clusterAssignment(indClusterCenters) = 1:length(indClusterCenters);

%[sortedrho,ii]=sort(rho,'descend');

%count=1;
 distanceSquare = squareform(distances);
while (~isempty(find(clusterAssignment==0)))
    
for n=1:length(indClusterCenters)
    thisrect=distanceSquare(clusterAssignment==n,clusterAssignment==0) ;
    iinds=find(clusterAssignment==n);
    jinds=find(clusterAssignment==0);
    [~,smallestDistanceInd]=min(thisrect(:));
    dimensions=size(thisrect);
    [ii,jj]=ind2sub(dimensions,smallestDistanceInd(1));
    thisnextpoint(n)=jinds(jj(1));
end
[~,ii]=max(rho(thisnextpoint));


%if (clusterAssignment(ii(count)) ==0)

   distsToAssignedClusters=distanceSquare( thisnextpoint(ii),clusterAssignment>0) ;
   %iinds=find(clusterAssignment==0);
   jinds=find(clusterAssignment>0);
   %dimensions=size(distsToAssignedClusters);
   [y,smallestDistanceInd]=min(distsToAssignedClusters(:));
   %[ii,jj]=ind2sub(dimensions,smallestDistanceInd(1));
    clusterAssignment(thisnextpoint(ii))=    clusterAssignment(jinds(smallestDistanceInd(1)));
    %rho(ii(count))=max(rho(clusterAssignment== clusterAssignment(jinds(smallestDistanceInd(1)))));
    
%    count=count+1;
    
end