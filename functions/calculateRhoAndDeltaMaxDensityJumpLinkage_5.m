%%
%%%%%%%%%%%%% what this function does %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1) calculates delta and rho using the maxJump density
%2) fixed for n dim
%4) max jump is fixed to be maxdensity - value - it gets more linear
%5) calculates density lines fast 
%6) calculates max jump using linkage



 function [rho,delta,maxjump,densityNorm] = calculateRhoAndDeltaMaxDensityJumpLinkage_5(data,nsamps,densityType,kdedens,linedensityMethod,numextra,doplot)

%%
% % % % % % %%%%%%%%%%%%%%%%%%% test function %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     nsamps = 10;
% %   data = boutDataPCASample(:,1:3);
% linedensityMethod ='fast';

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% do local density %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clear densitylines
% kdedens=kde(data',densityType);
%%
%%%%%%%%%%%%%%%% calculate rho using local density %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rho = evaluate(kdedens,data');


%%
%%%%%%%%%%%%%%%%%%%%%%%% calculate density lines fast %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

whichMethod = 'both';

% doplot = 1;
distfun = pdist(data);
switch linedensityMethod
    
  case 'slow'
% tic
 [densityLineMap]=slowDensityLinesCalc_4(data,kdedens,rho,distfun,whichMethod,nsamps,doplot);

  case 'slowPar'
 [densityLineMap]=slowDensityLinesCalc_3(data,kdedens,rho,distfun,whichMethod,nsamps,doplot);
    
 
  case 'medium'
        whichMethod = 'extra';
 [densityLineMap]=mediumDensityLinesCalc(data,kdedens,rho,distfun,whichMethod,nsamps,numextra,doplot);
 
  case 'mediumPar'
        whichMethod = 'extra';
 [densityLineMap]=mediumDensityLinesCalc_2(data,kdedens,rho,distfun,whichMethod,nsamps,numextra,doplot);
    
  case 'fast'     
 [densityLineMap]=fastDensityLinesCalc(data,kdedens,rho,distfun,whichMethod,nsamps,doplot);
 
  case 'fastPar'     
 [densityLineMap]=fastDensityLinesCalc_3(data,kdedens,rho,distfun,whichMethod,nsamps,doplot);
 
 
 
   
 
 
% toc
    otherwise 
    disp('line density method not specified...');  
end

% imagesc(densityLineMap)
%%
%%%%%%%%%%%%%%% normalize density line map by highest rho %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

maxDensity = max(rho);
% maxDensity = max(max(density));
densityNorm = maxDensity - densityLineMap;


% %%
% %%%%%%%%%%%
% 
% densityNorm2 = densityNorm;
% 
% for n = 1 : size(densityNorm,1)
%     
%     thisPointRho = rho(n);
%     
%     thisPointMiniDipps = densityNorm(n,:);
%     
%     indUppHill = find(thisPointMiniDipps < thisPointRho);
%     
%     
%     densityNorm2(n,indUppHill) = thisPointRho;
%     
%     
%     
%     
%     
% end

%point of highest density is not zero in diagonal
for n=1:length(rho)
densityNorm(n,n)=0;
end


%%
%%%%%%%%%%%%%%% calculate max jump in density space %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%finds paths with smaller dipp between two points

%do single link clustering (distance method euclidean) in norm density line map
t = linkage(squareform(densityNorm));

%determine the cophenetic distances between data points in tree
[c,D] = cophenet(t,squareform(densityNorm));

maxjump = squareform(D,'tomatrix');



%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% calculate delta %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  delta = calculateDelta(rho,densityNorm);

  delta = calculateDelta_3(rho,maxjump);

% maxRho = max(rho);
% 
% %make delta linear
% delta = maxRho - power(delta1,-1);

% figure
% % subplot(2,3,1)
% plot(rho(:),delta(:),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
