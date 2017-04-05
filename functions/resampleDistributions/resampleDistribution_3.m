function [resampledDist] = resampleDistribution_3(origDist,nPoints,doPlot)



%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%% test function %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% nPoints = length(data);
% doPlot = 1;
% origDist = data(:,1:3);

%%
%%%%%%%%%%%%%%%% open variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

numInput=size(origDist,1);
nDimensions=size(origDist,2);
% size(origDist)

randompoints = zeros(nPoints,nDimensions+1);
randomweights = zeros(nPoints,nDimensions);
 
%%
%%%%%%%%%%%%%  make random weights %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
for nn = 1 : nDimensions
    
randomweights(:,nn) = rand(nPoints,1);

end

randomweights = diff([zeros(nPoints,1) sort(randomweights')' ones(nPoints,1)]')';

newpoints = zeros(nPoints,nDimensions);

%%
%%%%%%%%%%%%%% find max and min for each dimension %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

maxshape = zeros((nDimensions + 1),nDimensions);

for nn = 1 : nDimensions
    
    thisvector = zeros(1,nDimensions);
    thisvector(nn) = max(origDist(:,nn))-min(origDist(:,nn));
%     maxshape = [maxshape; thisvector]
    maxshape(nn +1,:) = thisvector;
%     length(thisvector)
%      pause
end

%%
%%%%%%%%%%%%% calculate max volume of simplex %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
factorialNumb = 1/factorial(nDimensions);
maxvolume = (factorialNumb)*det(maxshape(2:end,:));
% tic
for whichpoint = 1:nPoints
   
    done = 0;
    while (done == 0)
       
  for nn = 1:nDimensions+1
      
    %make random points           
    randompoints(whichpoint,nn) = randi(numInput,1); 

  end
  
%distance=sqrt(  power(r(randompoints(whichpoint,1),1)-r(randompoints(whichpoint,2),1),2)+...
%    power(r(randompoints(whichpoint,1),2)-r(randompoints(whichpoint,2),2),2))/maxdistance;
%trianglearea=polyarea([r(randompoints(whichpoint,1),1) r(randompoints(whichpoint,2),1) r(randompoints(whichpoint,3),1)]...
 %   ,[r(randompoints(whichpoint,1),2) r(randompoints(whichpoint,2),2) r(randompoints(whichpoint,3),2)])/maxarea;

 thiszero = origDist(randompoints(whichpoint,1),:);
%  thisshape = zeros(1,nDimensions);
 thisshape = zeros(nDimensions+1 ,nDimensions);
 
for nn = 2 : nDimensions+1 
    
    %subtract zero
    thisvector = origDist(randompoints(whichpoint,nn),:) - thiszero;
    
%     thisshape(nn,:) = [thisshape; thisvector];
    thisshape(nn,:) = thisvector;
    
end
 
%%
%%%%%%%%%%%% calculate simplex volume %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 simplexvolume = (factorialNumb)*det(thisshape(2:end,:));
 simplexvolume = simplexvolume/maxvolume;%make volume dependent of size if simplex

 %%
 %%%%%%%%%%%%%% end while loop %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %place where iteration ends
    %if ((rand(1,1)<power(distance,2)))
    if (rand(1,1) < simplexvolume)
        
        done=1;

    end
    
    end
   % whichpoint
   
end
% toc

for nn = 1:nDimensions+1
    
newpoints = newpoints + origDist(randompoints(:,nn),:).*repmat(randomweights(:,nn),[1 nDimensions]);

end

%%
%%%%%%%%%%%%%%%%% make plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ((nDimensions>1) && (doPlot))

figure
subplot(1,3,1)
plot(origDist(:,1),origDist(:,2),'k.')
axis([min(origDist(:,1)) max(origDist(:,1)) min(origDist(:,2)) max(origDist(:,2))] )
%hist3(origDist(:,1:2),{min(origDist(:,1)):(max(origDist(:,1))-min(origDist(:,1)))/100:max(origDist(:,1)),...
   % min(origDist(:,2)):(max(origDist(:,2))-min(origDist(:,2)))/100:max(origDist(:,2))})
%axis([-15 15 -10 10]);
axis square
box off

subplot(1,3,2)


plot(newpoints(:,1),newpoints(:,2),'k.')
axis([min(origDist(:,1)) max(origDist(:,1)) min(origDist(:,2)) max(origDist(:,2))] )
%hist3(newpoints(:,1:2),{min(origDist(:,1)):(max(origDist(:,1))-min(origDist(:,1)))/100:max(origDist(:,1)),...
   % min(origDist(:,2)):(max(origDist(:,2))-min(origDist(:,2)))/100:max(origDist(:,2))})
 axis square
 box off

subplot(1,3,3)   
  plot(origDist(:,1),origDist(:,2),'k.')
  hold on
  plot(newpoints(:,1),newpoints(:,2),'g.')
  axis square
  box off

drawnow



end

resampledDist=newpoints;
