function radius=nballRadius(volume, nDim)

radius=power(gamma((nDim/2)+1),1/nDim)*(power(volume,1/nDim))/sqrt(pi);

return