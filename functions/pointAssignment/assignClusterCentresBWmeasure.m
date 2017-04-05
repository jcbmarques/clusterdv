%%
%%%%%%%%%%%%%%% what th1s does %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% it assigns points according to BWmeasure... it does not work and I don't know why 


%%
%%%%%%%%%%%%%%%%%%%%%%% test function %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
centers = sortedClusterCenters;

centers2 = centers(1:3);


% figure 
% plot(data(:,1),data(:,2), '.')
% hold on
% plot(data(centers2,1),data(centers2,2), 'ro')


%%
%%%%%%%%%%%%%% calculate distances between points %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% threshold = 0;
distances = pdist(data,'euclidean');

distanceSquare = squareform(distances);


clusterAssignment = zeros(1,length(data));
coreHalo = zeros(1,length(data));

%assign cluster centars
clusterAssignment(centers2) = 1:length(centers2);
coreHalo(centers2) = 1;

count = 1;
 while (~isempty(find(clusterAssignment == 0)))%goes until all points are assigned
    
    
%%
%%%%%%%%%%%%%% find closest points to each cluster %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for n=1:length(centers2)%loop through clusters assigns one point per cluster...
    
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
%%%%%%%%%%%%%%%%%% assign points to each cluster %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%find of the points which has the higher density
    [~,nn] = max(rho(thisnextpoint));


% for nn = 1 : length(thisnextpoint)%loop through each point
    
    
   
    BWmeasure = zeros(1,length(centers2));

    for nnn = 1 : length(centers2)%loop through each cluster
    
    clusterAssignmentTemp = clusterAssignment;
    
    %assign to this cluster 
    clusterAssignmentTemp(thisnextpoint(nn)) = clusterAssignment(centers2(nnn));
    
    %%
    %%%%%%%%%%%%%%% calculate BWmeasure %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    withinclusterdistz = [];
    betweenclusterdistz = [];
    
    for f = 1 : length(centers2)%loop through clusters
    
       

    withinclusterdistz = [withinclusterdistz sum(maxjump3(clusterAssignmentTemp == f,clusterAssignmentTemp == f)')];
    
     
    otherclusters=(clusterAssignment ~= f) & (clusterAssignment~=0);
    
    
    betweenclusterdistz = [betweenclusterdistz sum(maxjump3(clusterAssignmentTemp == f,otherclusters)')];
    
    
    end
    
    betw = mean(betweenclusterdistz);
    with = (withinclusterdistz);
%     size(betweenclusterdistz)
    BWmeasure(nnn) = betw-with;
    
    end
    
   
    
    %%
    %%%%%%%%%%%%%% determine thisnextpoint assignement %%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [~, ind1] = max(BWmeasure);
    
    clusterAssignment(thisnextpoint(nn)) = ind1;
    
    BWmeasureAll(count) = BWmeasure(ind1);
% end
count = count + 1;



    
    
 end
 
 
 %%
%%%%%%%%%%%%%%%%% make plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
colorz='rgbcmyk';

figure
plot(data(1,:),data(2,:),'.')
for t = 1 : length(centers(1:3))

hold on

plot(data(clusterAssignment==t,1),data(clusterAssignment==t,2),strcat(colorz(mod(t-1,7)+1),'.'))
 hold on
 plot(data(centers(t),1),data(centers(t),2),'ko')

end

 