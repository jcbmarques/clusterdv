%%
%%%%%%%%%%%%%%%%% what this does %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%this function decides cluster centers by choosing a level on the
%dendrogram of clusters




function [indChoosenClusterCenters] = decideClusterCentersByDendrogramGap_3(data,tree,clusterCentersSortedIdx,realRho,SImeasure,SImeasureRandThreshold)



%%
%%%%%%%%%%%%% excludes cluster centers that are bellow threshold %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isempty(SImeasureRandThreshold)
indNoiseClusters = find(SImeasure(clusterCentersSortedIdx) < SImeasureRandThreshold);
clusterCentersSortedIdx(indNoiseClusters) =[];
end


%%
%%%%%%%%%%%%%%%%%%%%% calculate SImeasure jumps %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%get SImeasures of the possibe cluster centers
clusterSImeasure = SImeasure(clusterCentersSortedIdx);

%calculate jumps - add zero at end to test possibility of all clusters to be true
clusterSImeasureDiff = [abs(diff([clusterSImeasure 0]))];

%%
%%%%%%%%%%%%%%%%%%% find jumps in dedrogram %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%threshold if there would be no levels in dedrogram - uniform distribution
normThreshold = sum(clusterSImeasureDiff)./length(clusterSImeasureDiff);

%find gaps in dendrogram
indGaps = find(clusterSImeasureDiff > normThreshold);
gapsVals = clusterSImeasureDiff(indGaps);

%%
%%%%%%%%%%%%%% calculate normalized gap %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

normalizedGap = (clusterSImeasureDiff - normThreshold) / ( max(clusterSImeasureDiff) - normThreshold );



%%
%%%%%%%%%%%%%%%%%%%%%% make initial plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%make decision plot 
figure
subplot(2,2,1)
plot(realRho(:),SImeasure(:),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k')
hold on
xlabel('\rho')
ylabel('-miniDipp/\rho + 1')
axis([0 max(realRho), -0.1 1.1])   
axis square


%make SImeasure plot
subplot(2,2,2)
hold on
plot(clusterSImeasure, '-k')
hold on
line([0 length(clusterSImeasure)+1],[normThreshold normThreshold],'color','green')
plot(1:length(clusterSImeasure),clusterSImeasure, 'k.')
plot(1:length(clusterSImeasureDiff),clusterSImeasureDiff, '-b.')

plot(1:length(clusterSImeasureDiff),clusterSImeasureDiff, 'b.')
axis square

%make 2D data plot
subplot(2,2,3)

if size(data,2) == 1%case of 1D data
    
  [nData, xData]= hist(data,size(data,1)./10) ;
  plot(xData,nData, '-k')
  axis square
  
else %more than 2d 
    
plot(data(:,1),data(:,2), 'k.')
axis square
xlabel('dim 1')
ylabel('dim 2')

end


subplot(2,2,4)
[~,~,perm] = dendrogram(tree, length(clusterSImeasure));
axis([min(perm)-1 max(perm)+1 0 1]) 

axis square
 for ii = 1 : length(indGaps)
 
     
     line([0, length(clusterSImeasure)+1],[clusterSImeasure(indGaps(ii)), clusterSImeasure(indGaps(ii))],'color',[normalizedGap(indGaps(ii)) 0 0])
% plot(indGaps,clusterSImeasure(indGaps), 'o','color',[fractionGap(ii),0,0])
%  plot(indGaps(ii),clusterSImeasure(indGaps(ii)), 'o','color',[gapsVals(indGaps(ii)),0,0])
% plot(indGaps(ii),clusterSImeasure(indGaps(ii)), 'o','color',col(idx(ii),:))

 end
 title('click on line to choose number of clusters')
% subplot(1,2,2)

%%
%%%%%%%%%%%%% choose clusters by clicking near correct line %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%click once
[~,yClick] = ginput(1);

[~,indGapsChoosen,~] = findnearest(yClick,clusterSImeasure(indGaps));

indChoosenClusterCenters = clusterCentersSortedIdx(1:indGaps(indGapsChoosen));


%%
%%%%%%%%%%%%%%%%% make plots after decisions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clf
%make decision plot 
subplot(2,2,1)
plot(realRho(:),SImeasure(:),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k')
hold on
plot(realRho(indChoosenClusterCenters),SImeasure(indChoosenClusterCenters),'o','MarkerSize',5,'MarkerFaceColor','r','MarkerEdgeColor','r')
xlabel('\rho')
ylabel('-miniDipp/\rho + 1')
axis([0 max(realRho), -0.1 1.1])   
axis square


%make SImeasure plot
subplot(2,2,2)
hold on
plot(clusterSImeasure, '-k')
hold on
line([0 length(clusterSImeasure)+1],[normThreshold normThreshold],'color','green')
plot(1:length(clusterSImeasure),clusterSImeasure, 'k.')
plot(1:indGaps(indGapsChoosen),clusterSImeasure(1:indGaps(indGapsChoosen)),'o','MarkerSize',5,'MarkerFaceColor','r','MarkerEdgeColor','r')



plot(1:length(clusterSImeasureDiff),clusterSImeasureDiff, '-b.')
plot(1:length(clusterSImeasureDiff),clusterSImeasureDiff, 'b.')

plot(indGaps(indGapsChoosen),clusterSImeasureDiff(indGaps(indGapsChoosen)),'o','MarkerSize',5,'MarkerFaceColor','r','MarkerEdgeColor','r')

axis square

%make 2D data plot
subplot(2,2,3)

if size(data,2) == 1%case of 1D data
    
  [nData, xData]= hist(data,size(data,1)./10) ;
  plot(xData,nData, '-k')
  hold on
%   line([],[],'color','red')
  axis square
  
else %more than 2d 
    
plot(data(:,1),data(:,2), 'k.')
hold on
plot(data(indChoosenClusterCenters,1),data(indChoosenClusterCenters,2),'o','MarkerSize',10,'MarkerFaceColor','r','MarkerEdgeColor','r')

axis square
xlabel('dim 1')
ylabel('dim 2')

end

%make dendrogram with level lines
subplot(2,2,4)
[~,~,perm]  = dendrogram(tree, length(clusterSImeasure));
axis([min(perm)-1 max(perm)+1 0 1]) 

axis square
%  for ii = 1 : length(indGaps)
%  
%      
%      line([0, length(clusterSImeasure)+1],[clusterSImeasure(indGaps(ii)), clusterSImeasure(indGaps(ii))],'color',[normalizedGap(indGaps(ii)) 0 0])
% % plot(indGaps,clusterSImeasure(indGaps), 'o','color',[fractionGap(ii),0,0])
% %  plot(indGaps(ii),clusterSImeasure(indGaps(ii)), 'o','color',[gapsVals(indGaps(ii)),0,0])
% % plot(indGaps(ii),clusterSImeasure(indGaps(ii)), 'o','color',col(idx(ii),:))
% 
%  end
      line([0, length(clusterSImeasure)+1],[clusterSImeasure(indGaps(indGapsChoosen)), clusterSImeasure(indGaps(indGapsChoosen))],'color','red')


 title(length(indChoosenClusterCenters))
% subplot(1,2,2)