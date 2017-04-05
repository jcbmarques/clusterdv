# clusterdv
----------------------------------------------------------------------------
Density valley clustering package
----------------------------------------------------------------------------

This package includes the Matlab implementation of density valley clustering 
(clusterdv). Clusterdv is a density based clustering method and to estimate 
local densities uses the Kernel Density Estimate (kde) Matlab-based toolbox 
written by Alex Ihler and Mike Mandel (freely available in 
http://www.ics.uci.edu/~ihler/code/kde.html). The kde package is included 
in the clusterdv package (for details see KdeReadme). The rest of the 
functions and code were writen by Joao Marques and Michael Orger. The 
authors may be contacted via email at: jcbmarques@gmail.com and 
michael.orger@neuro.fchampalimaud.org.

The clusterdv package also includes example data sets with known ground truth 
that can be used to test the clustedv method: 

easy5cluster1000points.mat 	- from this study

elongatedWith2points.mat 	- from this study

exclamationMark.mat 		- from this study

flame_240points_2d_2c.mat 	- Fu  L, Medico  E (2007) FLAME, a novel 
fuzzy clustering method for the analysis of DNA microarray data. 
BMC bioinformatics 8:1–25.

spiral_312points_2d_3c.mat 	- Chang H, Yeung DY (2008) Robust 
path-based spectral clustering. Pattern Recogn 41:191–203.

agregation_788points_2d_7c.mat 	- Gionis A, Mannila H, Tsaparas P (2007)
 Clustering aggregation. Acm Transactions Knowl Discov Data 1:30.



------------------------------------------------------------------------------
Getting Started
------------------------------------------------------------------------------

To run the clusterdv package unzip and add the folder to the Matlab path. 
The clusterDv.m script opens a user interface and the user should click on 
one of the data sets included in the package or another data set with the 
correct file format: mat file with variable "data" inside, rows are data 
points and columns n dimensions of the data. The algorithm will automatically 
determine the number of clusters and assign each data point to the respective 
group. The groups are saved in the variable 'clusterAssignment' and the index 
of the cluster centers on the variable 'indChoosenClusterCenters'.

------------------------------------------------------------------------------
Relevant functions
------------------------------------------------------------------------------

findClusterCentersDensityValley_6.m (determines cluster centers by clusterdv)
------------------------------------------------------------------------------
important inputs: 
data
kdedens 		- if density kde object was calculated before hand. 
			  If variable is left empty it will be calculated 
			  inside the function.
densityType 		- kde can estimate densities using several methods. 
			  For adaptive Gaussians use 'local'. 
linedensityMethod 	- line density method. Can be 'slow', 'medium' or 
			  'fast'. It may use Matlab parallel toolbox: 
			  'slowPar','mediumPar', 'fastPar'.
numextra 		- for the line density method 'medium' or 'mediumPar'
			  defines the degree of extra lines to calculate.
			  Normaly the quare root of the number of points
			  is sufficient. 
nsamps 			- number of divisions used to calculate density 
			  lines. Often 10 is enough.
multirep 		- number of reference distribution repetitions.
numbPointsToShow 	- number of points to show in plot.
clusterThreshold 	- avoids 'cluster centers' bellow this value.
resampleMethod 		- methods do make reference distribution. Can be 
			  'onion' or 'simplex'.
scalingFactor 		- factor to scale the density estimation. Put 1
			  for no scaling. 
makeplot 		- 1 produces plot, 0 no plot.

makeDendrogramByCenterExclusion_4.m (produces dendrogram according to SI values)
------------------------------------------------------------------------------
important inputs: 
data
SImeasure 		- produced by findClusterCentersDensityValley_6.m. 

decideClusterCentersAll_3.m (decision rule to determine number of clusters)
------------------------------------------------------------------------------
important inputs: 
data
SImeasureRandThreshold 	- SI threshold or outlier density threshold
decisionMethod          - method to decide number of clusters. It can be: 
			  by threshold of reference distributions 
			  ('allClusterCenters'), by clicking in level of 
			  dendrogram ('dendrogram'), by drawing square in 
			  decision plot ('square'), and by picking all cluster
			  centers that have greater density than 
			  SImeasureRandThreshold ('allExcludeOutliers').	

assignDataPointsAllCases_1.m (assigns individual data points to respective clusters)
------------------------------------------------------------------------------
important inputs: 
data
pointAssignmentMethod 	- Most usual method is 'distance'.
