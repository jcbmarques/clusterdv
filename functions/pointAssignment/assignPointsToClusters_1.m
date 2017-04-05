%%
%%%%%%%%%%%%% what this function does %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1) it assigns every point to the closest higher rho point
%2) creates a halo and a core according to the dc
%3) its +- the density peak cluster paper implementation
 


function [clusterCore,clusterHalo] = assignPointsToClusters_1(distanceSquare,indClusterCenters,ordrho,nneigh,dc,rho)




%%
%%%%%%%%%%% make -1 vector with cluster centers %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%make -1 vector with size of data points
cl = zeros(1, size(distanceSquare,1));
cl(:,:) = -1;

%assign cluster centers to correct cl and ordered 1 to end
cl(indClusterCenters) = 1 : length(indClusterCenters);



% %find cluster centers ind
% indClusterCenters  = find(cl > -1);

% numbClusters = length(indClusterCenters);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% define halo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ND = size(distanceSquare,1);

%make clusterHalo vector
clusterHalo = zeros(1,ND);

%assignation



for i=1:ND%loop through every point that is not a cluster center
    
  if (cl(ordrho(i)) == -1)%check if it is cluster centers
      
    cl(ordrho(i)) = cl(nneigh(ordrho(i)));
    
  end
  
end%loop through every point


%open halo vector
clusterCore = cl;
halo = cl;

%open bord_rho vector
bord_rho = zeros(1,length(indClusterCenters));
  
%loop through i points
 for i = 1:ND-1
     
    %loop through j points 
    for j = i+1:ND
        
      if ((cl(i) ~= cl(j)) && (distanceSquare(i,j) <= dc))
        
        %make rho average  
        rho_aver=(rho(i) + rho(j))/2.;
        
        if (rho_aver > bord_rho(cl(i))) 
            
          bord_rho(cl(i)) = rho_aver;
          
        end
        
        if (rho_aver > bord_rho(cl(j))) 
            
          bord_rho(cl(j)) = rho_aver;
          
        end
        
      end
      
    end
    
 end

%assign points erase halos
  for i=1:ND
    if (rho(i) < bord_rho(cl(i)))
      clusterCore(i) = 0;
      clusterHalo(i) = cl(i); 
    end
  end
  
  %%
%%%%%% calculate number of points in cluster center and cluster halo %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% for i = 1:numbClusters%loop through each cluster
%   nc=0;
%   nh=0;
%   for j = 1 : ND%loop through each data point
%       
%     if (cl(j)==i)%assign as core
%         
% %         clusterCore(j) = cl(j);
%         
%       nc = nc+1;
%     end
%     
%     if (halo(j)==i)%assign as halo 
%         
% %         clusterHalo(j) = halo(j);
%         
%       nh=nh+1;
%     end
%     
%   end
% %    fprintf('CLUSTER: %i CENTER: %i ELEMENTS: %i CORE: %i HALO: %i \n', i,icl(i),nc,nh,nc-nh);
% end  
