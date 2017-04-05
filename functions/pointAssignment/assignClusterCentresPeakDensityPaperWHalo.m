
function [clusterAssignment,clusterHalo] = assignClusterCentresPeakDensityPaperWHalo(data,rho,indClusterCenters,maxjump)

distances = pdist(data,'euclidean');

distanceSquare = squareform(distances);
maxd = max(max(distanceSquare));

%%
% %%%%%%%%%%%%% define halo threhold %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% clustersep=max(rho)-maxjump(indClusterCenters,indClusterCenters);
% threshold=max(min(clustersep));


%%
%%%%%%%%%%%%%%% calcualte nneigh %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[~,ordrho] = sort(rho,'descend');
delta2(ordrho(1)) = -1.;
nneigh(ordrho(1)) = 0;

for ii=2:length(data)%loop through all points except 1 that is already assigned
%     ii
   delta2(ordrho(ii)) = maxd;
   
   for jj=1:ii-1
       
     if(distanceSquare(ordrho(ii),ordrho(jj)) < delta2(ordrho(ii)))
         
        delta2(ordrho(ii)) = distanceSquare(ordrho(ii),ordrho(jj));
        nneigh(ordrho(ii)) = ordrho(jj);
        
     end
     
   end
end

dc = 0;

[clusterAssignment,clusterHalo] = assignPointsToClusters_1(distanceSquare,indClusterCenters,ordrho,nneigh,dc,rho);


%%
%%%%%%%%%%%%%%% make halo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


