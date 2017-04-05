function rndpoint=randomSurfacePointHypersphere(radius, nDims)


initialpoint=randn([nDims 1]);

normF=1/sqrt(sum(power(initialpoint,2)));

rndpoint=radius*normF*initialpoint;