function   [densityLineMap]=slowDensityLinesCalc_4(thisdata,kdedens,rho,distfun,whichMethod,nsamps,doplot);

%%
%%%%%%%%%%%%%%% test function %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% thisdata = data;

%%
%%%%%%%%%%%% determine start and end points %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


count=1;
numbDim = size(thisdata,2);


startpoints = zeros((size(thisdata,1)*(size(thisdata,1)-1))/2,numbDim);
endpoints = zeros((size(thisdata,1)*(size(thisdata,1)-1))/2,numbDim);


for n=1:size(thisdata,1)-1%loop through each point
% n
for nn=n+1:size(thisdata,1)%loop through each other point
    
startpoints(count,:)=thisdata(n,:);
endpoints(count,:)=thisdata(nn,:);

count=count+1;
end

end

%%
%%%%%%%%%%%%%%%%%%% calculate density line between points %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
densitylines = zeros(size(startpoints,1),nsamps);

for n=1:nsamps
% n
densitylines(:,n) = evaluate(kdedens,(startpoints*n/(nsamps+1)+endpoints*(nsamps+1-n)/(nsamps+1))');

end

[density,~] = min(densitylines,[],2);


densityLineMap = squareform(density);


if doplot == 1
    
figure
plot(thisdata(:,1),thisdata(:,2),'.')
hold on   
box off    
axis square  

end


