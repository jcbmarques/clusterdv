function   [densityLineMap]=mediumDensityLinesCalc_2(thisdata,kdedens,rho,distfun,whichMethod,nsamps,numextra,doplot);

linkageInfo=minDistGraph(distfun);
allsq=squareform(distfun);




%kdedens=kde(thisdata','localp');
rho=evaluate(kdedens,thisdata');
allUpConns=zeros(size(rho));
for n=1:length(rho)
    betterrhos=find(rho>rho(n));
    if (~isempty(betterrhos))
        [~,thisi]=min(allsq(n,betterrhos));
        allUpConns(n)=betterrhos(thisi);
    else
            allUpConns(n)=n;
    end 
end

allExtraConns=[];
[~,sorti]=sort(allsq);
for n=1:numextra
    allExtraConns=[allExtraConns sorti(n+1,:)];
end





if (doplot)
figure
hold on

for nn=1:numextra
for n=1:length(linkageInfo.preLinks)
line([thisdata(n,1) thisdata(allExtraConns(n+(nn-1)*length(rho)),1)],...
    [thisdata(n,2) thisdata(allExtraConns(n+(nn-1)*length(rho)),2)],'Color',[0 0 1],'LineWidth',1)
end
end

for n=1:length(linkageInfo.preLinks)
line([thisdata(n,1) thisdata(allUpConns(n),1)],...
    [thisdata(n,2) thisdata(allUpConns(n),2)],'Color',[1 0 0],'LineWidth',5)
end

end

switch whichMethod
    case 'minlink'
startpoints=linkageInfo.preLinks;
endpoints=linkageInfo.postLinks;
    case 'upconn'
startpoints=1:length(allUpConns);
endpoints=allUpConns;
    case 'both'
startpoints=[linkageInfo.preLinks 1:length(allUpConns)];
endpoints=[linkageInfo.postLinks allUpConns];
allcombos=unique(startpoints+endpoints*(length(allUpConns)+1));
disp(['saved ' num2str(length(startpoints)-length(allcombos)) ' out of ' num2str(length(startpoints))])
startpoints=mod(allcombos,length(allUpConns)+1);
endpoints=(allcombos-mod(allcombos,length(allUpConns)+1))/(length(allUpConns)+1);
    case 'extra'
startpoints=[linkageInfo.preLinks 1:length(allUpConns) repmat(1:length(allUpConns),1,numextra)];
endpoints=[linkageInfo.postLinks allUpConns allExtraConns];
allcombos=unique(startpoints+endpoints*(length(allUpConns)+1));
disp(['saved ' num2str(length(startpoints)-length(allcombos)) ' out of ' num2str(length(startpoints))])
startpoints=mod(allcombos,length(allUpConns)+1);
endpoints=(allcombos-mod(allcombos,length(allUpConns)+1))/(length(allUpConns)+1);

    otherwise 
        disp('wtf?');  
end

numlinks=length(startpoints);
%startpos=zeros(numlinks,size(thisdata,2));
%endpos=zeros(numlinks,size(thisdata,2));

%for count=1:numlinks
startpos=thisdata(startpoints,:);
endpos=thisdata(endpoints,:);
%end

densitylines=zeros(numlinks,nsamps);

parfor n=1:nsamps
disp(n)
densitylines(:,n)=evaluate(kdedens,(startpos*n/(nsamps+1)+endpos*(nsamps+1-n)/(nsamps+1))');
end

densitylines=[rho(startpoints)' densitylines rho(endpoints)'];


density = min(densitylines,[],2);

way1=sub2ind(size(allsq),startpoints,endpoints);
way2=sub2ind(size(allsq),endpoints,startpoints);


densityLineMap=zeros(size(allsq));
densityLineMap(way1)=density;
densityLineMap(way2)=density;

%densitysq=squareform(density);
%densitysq2=power(densitysq,-1);
%for n=1:size(densitysq,1)
%densitysq2(n,n)=max(densitysq2(:));
%end

%[maxjump]=createJumpMapWithDist(data,densitysq2);


if (doplot)
% figure
plot(thisdata(:,1),thisdata(:,2),'o', 'color','k','markerfacecolor','k','markersize', 2)
hold on
% for n=1:length(linkageInfo.preLinks)
% line([thisdata(linkageInfo.preLinks(n),1) thisdata(linkageInfo.postLinks(n),1)],...
%     [thisdata(linkageInfo.preLinks(n),2) thisdata(linkageInfo.postLinks(n),2)],'LineWidth',3)
% end

box off    
axis square  
axis off


end

