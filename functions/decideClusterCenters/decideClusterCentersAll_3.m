
%%
%%%%%%%%%%%%%%%%% what this does %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%this function decides number of cluster centers by different methods


function [indChoosenClusterCenters] = decideClusterCentersAll_3(data,tree,clusterCentersSortedIdx,realRho,SImeasure,SImeasureRandThreshold,decisionMethod)


%%
%%%%%%%%%%%%%% test function %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% decisionMethod = 'square';
% decisionMethod = 'dendrogram';



%%
%%%%%%%%%%%%% switch between decision methods %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch decisionMethod
    
    case 'dendrogram'

if isempty(tree)%if dendrogram was not made do square anyway
    
    [indChoosenClusterCenters] = decideClusterCentersSquare_2(data,tree,clusterCentersSortedIdx,realRho,SImeasure,SImeasureRandThreshold);
    
else
    
    [indChoosenClusterCenters] = decideClusterCentersByDendrogramGap_3(data,tree,clusterCentersSortedIdx,realRho,SImeasure,SImeasureRandThreshold);
    
end



    case 'square'

    [indChoosenClusterCenters] = decideClusterCentersSquare_2(data,tree,clusterCentersSortedIdx,realRho,SImeasure,SImeasureRandThreshold);
    
   
     
    case 'allClusterCenters'  
        % exclude cluster centers that are bellow threshold
        if ~isempty(SImeasureRandThreshold)
        indNoiseClusters = find(SImeasure(clusterCentersSortedIdx) < SImeasureRandThreshold);
        clusterCentersSortedIdx(indNoiseClusters) =[];
        end
        
        indChoosenClusterCenters = clusterCentersSortedIdx;
        
    case 'allExcludeOutliers'
        
        
     [indChoosenClusterCenters] = decideClusterCentersLine_2(data,tree,clusterCentersSortedIdx,realRho,SImeasure,SImeasureRandThreshold);
end



