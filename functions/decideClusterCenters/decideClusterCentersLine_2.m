%%
%%%%%%%%%%%%%% what does this do %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1) choose number of cluster centers by choosing rectangle in gui


 function [indChoosenClusterCenters] = decideClusterCentersLine_2(data,tree,clusterCentersSortedIdx,realRho,SImeasure,SImeasureRandThreshold)

%%
%%%%%%%%%%%%%% test function %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  tree = [];
% data = dataThisDataSetRand;

%%
%%%%%%%%%%%%% exclude cluster centers that are bellow threshold %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isempty(SImeasureRandThreshold)
indNoiseClusters = find(SImeasure(clusterCentersSortedIdx) < SImeasureRandThreshold);
clusterCentersSortedIdx(indNoiseClusters) =[];
end


%%
%%%%%%%%%%%% make decision plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
subplot(2,2,3)   
plot(data(:,1),data(:,2), 'k.')
axis square
xlabel('dim 1')
ylabel('dim 2')

% if makePlot == 1
  
    if ~isempty(tree)
    
   
subplot(2,2,4)
[~,~,perm] = dendrogram(tree);
axis square
axis([min(perm)-1 max(perm)+1 0 1]) 

if ~isempty(SImeasureRandThreshold)
    
    line([min(perm)-1 max(perm)+1],[SImeasureRandThreshold SImeasureRandThreshold],'color','g')
    
end


    end

%make colors
col = jet(length(clusterCentersSortedIdx));
invCol = flipud(col);
    
subplot(2,2,2)
plot(realRho(:),SImeasure(:),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k')
hold on

if ~isempty(SImeasureRandThreshold)
    
    line([min(realRho) max(realRho)],[SImeasureRandThreshold SImeasureRandThreshold],'color','g')
    
end

for n = 1 : length(clusterCentersSortedIdx)

plot(realRho(clusterCentersSortedIdx(n)),SImeasure(clusterCentersSortedIdx(n)),'o','MarkerSize',5,'MarkerFaceColor',invCol(n,:),'MarkerEdgeColor',invCol(n,:))
text(realRho(clusterCentersSortedIdx(n)),SImeasure(clusterCentersSortedIdx(n))+0.02,num2str(n))
% pause

end

axis square
xlabel('\rho')
ylabel('-miniDipp/\rho + 1')
title('make square to choose cluster centers')    
axis([0 max(realRho), -0.1 1.1])   

subplot(2,2,1)
plot(realRho(:),SImeasure(:),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k')
hold on
xlabel('\rho')
ylabel('-miniDipp/\rho + 1')
title('make square to choose cluster centers')    
axis([0 max(realRho), -0.1 1.1])   
axis square
% end

if ~isempty(SImeasureRandThreshold)
    
    line([min(realRho) max(realRho)],[SImeasureRandThreshold SImeasureRandThreshold],'color','g')
    
end


%%
%%%%%%%%%%%%% choose clusters by line %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%choose rect with mouse
% rect = getrect;   

%click once
[xClick,yClick] = ginput(1);


%find cluster centers in rect
indIndClusrerCenter = find(realRho(clusterCentersSortedIdx) > xClick );

indChoosenClusterCenters = clusterCentersSortedIdx(indIndClusrerCenter);

% figure
clf
subplot(2,2,3)   
plot(data(:,1),data(:,2), 'k.')
hold on
plot(data(indChoosenClusterCenters,1),data(indChoosenClusterCenters,2),'o','MarkerSize',10,'MarkerFaceColor','r','MarkerEdgeColor','r')

axis square
xlabel('dim 1')
ylabel('dim 2')

subplot(2,2,1)
plot(realRho(:),SImeasure(:),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k')
hold on
plot(realRho(indChoosenClusterCenters),SImeasure(indChoosenClusterCenters),'o','MarkerSize',5,'MarkerFaceColor','r','MarkerEdgeColor','r')
axis square
xlabel('\rho')
ylabel('-miniDipp/\rho + 1')
axis([0 max(realRho), -0.1 1.1]) 

subplot(2,2,2)
plot(realRho(:),SImeasure(:),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k')
hold on


for n = 1 : length(indChoosenClusterCenters)
plot(realRho(indChoosenClusterCenters(n)),SImeasure(indChoosenClusterCenters(n)),'o','MarkerSize',5,'MarkerFaceColor','r','MarkerEdgeColor','r')

text(realRho(indChoosenClusterCenters(n)),SImeasure(indChoosenClusterCenters(n))+0.02,num2str(indChoosenClusterCenters(n)))
% pause

end
axis square
xlabel('\rho')
ylabel('-miniDipp/\rho + 1')
title('make square to choose cluster centers')    
axis([0 max(realRho), -0.1 1.1])   


if ~isempty(tree)
    
   
subplot(2,2,4)
[~,~,perm] = dendrogram(tree);
axis square
 axis([min(perm)-1 max(perm)+1 0 1]) 
hold on

%find dendrogram threshold
dendrogramThreshold = min(SImeasure(indChoosenClusterCenters));

% line([0 dendrogramThreshold],[max(perm)+1 dendrogramThreshold])
line([0 max(perm)+1],[dendrogramThreshold dendrogramThreshold],'color','red')

title(length(indChoosenClusterCenters))
end

