%%%%%%%%%%%%%%%% what this function does %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Assigns data points to respective cluster center. It uses different methods
% to do this. 'distance' assigns points to closest cluster center.  

function [clusterAssignment] = assignDataPointsAllCases_1(data,indClusterCenters,rho,maxJump,pointAssignmentMethod,makeplot)

makeplot2 = 0;

%%
%%%%%%%%%%%%%% do cluster assignment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch pointAssignmentMethod
    
    case 'distance'
    
%mike distance point assignment 
[clusterAssignment] = assignClusterCentresOrderByDistance(data,indClusterCenters);

    case 'distance2'
%joao distance point assignment
[clusterAssignment] = assignPointsToClustersDistance_2(data,indClusterCenters,rho,makeplot2);

    case 'densityMinidipp'
        
%mike uses maxJump matrix instead of pdist but joins points only to points of higher density
[clusterAssignment] = assignClusterCentresOrderByDensityUseMindip(data,rho,maxJump,indClusterCenters);


    case 'minidipp'
        
%mike same as previous but uses mindip/smallest jump matrix instead of pdist
[clusterAssignment] = assignClusterCentresOrderByMindip(data,maxJump,indClusterCenters);

    case 'density'
        
% A version that joins clusters to the nearest point of higher density. 
[clusterAssignment] = assignClusterCentresOrderByDensity(data,rho,indClusterCenters);

    case 'pooledDensity'
        
% uses distances but gives the highest density of the cluster
[clusterAssignment] = assignClusterCentresOrderByPooledDensity(data,rho,indClusterCenters);

    case 'pooledDensity2'
    [clusterAssignment] = assignClusterCentresLinkToDensestClosePointPooledDensity(data,rho,indClusterCenters);

    case 'none'
    
    [clusterAssignment] = [];
        
    otherwise 
        disp('pointAssignmentMethod incorrect');  

end


%%
%%%%%%%%%%%%%%%% make assignment plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if makeplot == 1
    
uniqueClusterAssignment = unique(clusterAssignment);

col = jet(length(uniqueClusterAssignment));
figure
% plot3(data(:,1),data(:,2),rho, 'k.')
hold on

for n = 1 : length(uniqueClusterAssignment)
   
    indThisCluster = find(clusterAssignment == uniqueClusterAssignment(n));
    
%     plot(data(indThisCluster,1),data(indThisCluster,2), '.', 'color', col(n,:))
    plot3(data(indThisCluster,1),data(indThisCluster,2),rho(indThisCluster), '.', 'color', col(n,:))

    axis square
    box off
    xlabel('dim 1')
    ylabel('dim 1')

    
end

end



