function  linkageInfo=minDistGraph(distfun)

numpoints=ceil(sqrt(length(distfun)*2));
allsq=squareform(distfun);
biggestvalue=max(max(allsq));

D1=allsq+diag(-biggestvalue*ones(1,numpoints)); 
D2=D1;

k1=numpoints;

ct=1:2*numpoints-1;                    % Used in the loop below
i=1;                            %

stilltouse=ones(numpoints,1);
agglomerator=1:numpoints;


for j=1:k1-1
   % j
   inds=find(stilltouse);
  [v,r]=min(abs(D1(inds,inds))); %r is the row index of the min value for each column          % Find smallest distance entry which 
  r=inds(r);   % r is now a list of the true indices of v
  [v1,c]=min(v);   % corresponds to entities r and c.
  r=r(c);          % finds the correct r  
  c=inds(c);           %converts c to true original index     % Clustering level is v1.
%disp(r)
                     % Clustering level is v1.
%disp(c)
  rc=min(D1(r,:),D1(c,:));      % the min distance of r or c to all others negative if they are already clustered
  D1(r,:)=-biggestvalue*ones(1,k1);       %   set row and column r negative since they are already in another cluster 
  D1(:,r)=[-biggestvalue*ones(1,k1)]';    % Form new distance matrix
 stilltouse(r)=0;
  %rc(r)=[];
  D1(c,:)=rc;                   %
  D1(:,c)=rc'; 
 % D1(r,:)=[];
  %D1(:,r)=[]; 
  %
%allclusters
  
  level(i)=v1;          %the cluster level
  ent1(i)=ct(c);        %the first point clustered
  ent2(i)=ct(r);        %the second point clustered
  ent3(i)=ct(k1+i);     % what new cluster they belong to
  ct(r)=ent3(i);        % link this point to the new cluster
  ct(c)=ent3(i);       % link this point to the new cluster
  
  
  allinr=find(agglomerator==agglomerator(r));
  allinc=find(agglomerator==agglomerator(c));
  
  
  if (length(allinr)>1)
  if (length(allinc)>1)
  [v,rr]=min(abs(D2(allinr,allinc))); %r is the row index of the min value for each column          % Find smallest distance entry which 
  [v1,cc]=min(v);
  rr=allinr(rr);
  bestrs=rr(cc);
  bestcs=allinc(cc);
  else
   [v,rr]=min(abs(D2(allinr,allinc)));
      bestrs=allinr(rr);
      bestcs=allinc;
      
   end
  else
  if (length(allinc)>1)
      
   [v,cc]=min(abs(D2(allinr,allinc)));
      bestrs=allinr;
      bestcs=allinc(cc);
    
  else
   bestrs=allinr;
      bestcs=allinc;
  end
  end
  
  bestr(i)=bestrs;
  bestc(i)=bestcs;
  agglomerator(allinc)=agglomerator(r);

  i=i+1;
  
end

linkageInfo.preLinks=bestr;
linkageInfo.postLinks=bestc;
linkageInfo.level=level;
linkageInfo.ent1=ent1;
linkageInfo.ent2=ent2;
linkageInfo.ent3=ent3;
linkageInfo.ct=ct;
