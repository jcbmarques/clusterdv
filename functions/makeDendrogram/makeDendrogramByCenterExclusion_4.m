%%%%%%%%%%%%%% what does this do %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1) makes dendrogram according to 'SImeasure'


%%
      function [tree,clusterAssignmentAll,perm,clusterCentersSortedIdx] = makeDendrogramByCenterExclusion_4(data,SImeasure,maxNumbOfClusterCenters,rho,realRho,maxjump,pointAssignmentMethod,lowDensityCutOff,clusterCentersSortedIdx,makePlot)



%%
%%%%%%%%%%%%%%%%%% test function %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % clusterThreshold = 0.000001;%sometimes is has really small numbers - don't know why
% % maxNumbOfClusterCenters = 20;
% % makePlot = 1;
% % pointAssignmentMethod = 'distance';
% % lowDensityCutOff = 0;

% data = mappedX;
% SImeasure = SImeasureGroupClusters;
% maxNumbOfClusterCenters = 20;
% rho = rhoGroupClusters;
% realRho =realRhoGroupClusters;
% maxjump = maxjumpGroupClusters;
% pointAssignmentMethod ='pooledDensity2';
% lowDensityCutOff =0;
% clusterCentersSortedIdx = indChoosenClusterCentersGroupClustersSorted;
% makePlot = 1;




%%
%%%%%%%%%%%%%%%%% exclude low density clusters %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
indOutLiers = find(rho(clusterCentersSortedIdx) < lowDensityCutOff);

clusterCentersSortedIdx(indOutLiers) = [];

%%
%%%%%%%%%%%%%%%% limit number of clusters to try %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%case there are many cluster centers and we don't have time to wait
if length(clusterCentersSortedIdx) > maxNumbOfClusterCenters;
   
    
%order cluster centers by SImeasure
[~, SImeasureIdx] = sort(SImeasure, 'descend');

clusterCentersSortedIdx = SImeasureIdx(1:maxNumbOfClusterCenters);    
    
end

%get SImeasure for cluster centers in correct order
clusterCenterSImeasureSorted = SImeasure(clusterCentersSortedIdx);




%%
%%%%%%%%%%%%% do assignment excluding cluster centers %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Assign all cluster centers
makeplot2 = 0;
[clusterAssignmentAll] = assignDataPointsAllCases_1(data,clusterCentersSortedIdx,rho,maxjump,pointAssignmentMethod,makeplot2);

count = 1;
clusterCenterMerge = zeros(1,(length(clusterCentersSortedIdx)-1));

%make merge vector
for n = 2 : length(clusterCentersSortedIdx)
    
n

%     n = 2
    thisClusterCentersInd = clusterCentersSortedIdx(1:(end-n+1));
    
%     %get cluster ind with lowest SImeasure 
%     thisClusterInd = clusterCentersSortedIdx(n);
%     
%     %exclude this cluster center from indClusterCenters
%     indExclude = find(indClusterCenters2 == thisClusterInd);
%     
%     indClusterCenters2(indExclude) = [];

   
%     %do assignment
%     [clusterAssignment1] = assignClusterCentresOrderByDistance(data,indClusterCenters2);


% [clusterAssignment] = assignClusterCentresOrderByDistance(data,thisClusterCentersInd);
[clusterAssignment] = assignDataPointsAllCases_1(data,thisClusterCentersInd,rho,maxjump,pointAssignmentMethod,makeplot2);


% clusterAssignment(clusterCentersSortedIdx(8))


%get ind of previous cluster center
previousClusterCenterInd = clusterCentersSortedIdx((end-n+2));

%determine to which cluster it now belongs

clusterCenterMerge(count) = clusterAssignment(previousClusterCenterInd);

count = count + 1;

% %make plot
% [~] = plotMaker_clusterAssignment_1(data,thisClusterCentersInd,clusterAssignment);



end

%%
%%%%%%%%%%%%%%%% make tree %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% t = linkage(areaBetweenClusters);
% 
% figure
% [H,T,outperm] = dendrogram (t);
% 

clusterCenterSImeasureSortedInv = wrev(clusterCenterSImeasureSorted);

clusterCentersSortedIdxInv = wrev(clusterAssignmentAll(clusterCentersSortedIdx));

tree = zeros(length(clusterCenterMerge),3);

threeLeafsInds = clusterCentersSortedIdxInv;
threeMergeInds = clusterCenterMerge;


for n  = 1 : length(clusterCenterMerge)

% n=1
    thisClusterInd = threeLeafsInds(n);
    thisThreeMergeInds = threeMergeInds(n);
    
    %fill three
    tree(n,1) = thisClusterInd;
    tree(n,2) = thisThreeMergeInds;
    tree(n,3) = clusterCenterSImeasureSortedInv(n);
    
    
    
    
   %update leaf inds
   newLeafInd = max(threeLeafsInds) + 1;
   
   ind1 = find(threeLeafsInds == thisClusterInd);
   ind2 = find(threeLeafsInds == thisThreeMergeInds);
   indAll1 = unique([ind1 ind2]);
   
   ind3 = find(threeMergeInds == thisClusterInd);
   ind4 = find(threeMergeInds == thisThreeMergeInds );
   indAll2 = unique([ind3 ind4]);
   
   
   threeLeafsInds(indAll1) = newLeafInd;
  
   threeMergeInds(indAll2) = newLeafInd;
 

end

%%
%%%%%%%%%%%%%%%%%% make plot to see possible cluster centers %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



if makePlot == 1
    
figure   
subplot(1,2,2)
[~,~,perm] = dendrogram(tree,maxNumbOfClusterCenters);
axis square
axis([min(perm)-1 max(perm)+1 0 1]) 
%make colors
col = jet(length(clusterCentersSortedIdx));
invCol = flipud(col);

subplot(1,2,1)
plot(realRho(:),SImeasure(:),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k')
hold on

for n = 1 : length(clusterCentersSortedIdx)

plot(realRho(clusterCentersSortedIdx(n)),SImeasure(clusterCentersSortedIdx(n)),'o','MarkerSize',5,'MarkerFaceColor',invCol(n,:),'MarkerEdgeColor',invCol(n,:))
text(realRho(clusterCentersSortedIdx(n)),SImeasure(clusterCentersSortedIdx(n))+0.02,num2str(n))
% pause


    

end

axis square
xlabel('\rho')
ylabel('-miniDipp/\rho + 1')
    
    
else    
    
% [~,~,perm] = dendrogram(tree,maxNumbOfClusterCenters);
perm =[];
end
