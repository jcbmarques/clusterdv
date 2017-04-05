function [resampledData]=resampleDensityMatching(inputRhos,nDims);

sortedRhos=sort(inputRhos,'descend');

actualLocalDensity=sortedRhos*length(inputRhos);
totalVolume=0;
radiusRequired(1)=0;
for n=1:length(actualLocalDensity)
    volumeRequired=1/actualLocalDensity(n);
    radiusRequired(n+1)=nballRadius(volumeRequired+totalVolume, nDims);
    totalVolume=totalVolume+volumeRequired;
end

    whichSpheres=randi(length(inputRhos),[length(inputRhos),1]);
    resampledData=zeros(length(whichSpheres),nDims);
for n=1:length(whichSpheres)
    %highval=radiusRequired(n+1);
    lowval=power(radiusRequired(n)/radiusRequired(n+1),nDims);
    randval=power(lowval + (1-lowval)*rand([1,1]),1/nDims);
     r = randval*radiusRequired(n+1);
%      disp([num2str(radiusRequired(n)) '  ' num2str(r) '  ' num2str(radiusRequired(n+1)) '  ' ])
    resampledData(n,:)=randomSurfacePointHypersphere(r, nDims);
end


%%
