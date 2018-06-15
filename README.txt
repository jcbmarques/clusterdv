==============================================================================
Density valley clustering package
==============================================================================

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
(loacated on the data folder) that can be used to test the clustedv method: 

A1_3000p_2d_20c                   - Karkkainen, I. and Franti, P. (2002) Dynamic local 
				  search for clustering with unknown number of clusters. 
				  Pattern Recognition.

A2_5000p_2d_35c                   - Karkkainen, I. and Franti, P. (2002) Dynamic local 
				  search for clustering with unknown number of clusters. 
				  Pattern Recognition.

A3_7500p_2d_50c                   - Karkkainen, I. and Franti, P. (2002) Dynamic local 
				  search for clustering with unknown number of clusters. 
				  Pattern Recognition.

agregation_788p_2d_7c.mat 	- Gionis A, Mannila H, Tsaparas P (2007)
				  Clustering aggregation. Acm Transactions 
			          Knowl Discov Data 1:30.

beep20_550p_2d_2c		- from this study

bone_marrow_38p_3d_3c 		- Monti, S. et al. (2003) Consensus clustering: a resampling-based
				  method for class discovery and visualization of gene 
			          expression microarray data. Machine learning 52, 91–113

cassini_1250p_2d_3c 		- Wiwie, C. et al. (2015) Comparing the performance of biomedical
				  clustering methods. Nat Meth 12, 1033–1038

easy2_600p_2d_2c		- from this study

cuboid_250p_3d_4c               - Wiwie, C. et al. (2015) Comparing the performance of biomedical
				  clustering methods. Nat Meth 12, 1033–1038

easy5_1000p_2d_5c		- from this study

exclamationMark1_500p_2d_2c     - from this study

exclamationMark2_500p_2d_2c     - from this study

exclamationMark3_186p_2d_3c     - from this study

flame_240p_2d_2c		- Fu  L, Medico  E (2007) FLAME, a novel fuzzy 
				  clustering method for the analysis of DNA 
				  microarray data. BMC bioinformatics 8:1–25.

R15_600p_2d_15c 		- Veenman, C.J. and Reinders, M. (2002) A maximum 
				  variance cluster algorithm. IEEE Transactions 
				  on Pattern Analysis and Machine Intelligence 24, 1273–128

Rodriguez1_1000p_2d_5c 		- Rodriguez, A. and Laio, A. (2014) Clustering by fast search
				  and find of density peaks. Science 344, 1492–1496

Rodriguez2_4000p_2d_5c		- Rodriguez, A. and Laio, A. (2014) Clustering by fast search
				  and find of density peaks. Science 344, 1492–1496

S1_5000_2d_15c			- Fränti, P. and Virmajoki, O. (2006) Iterative shrinking method
				  for clustering problems. Pattern Recognition 39, 761–775

S2_5000_2d_15c			- Fränti, P. and Virmajoki, O. (2006) Iterative shrinking method
				  for clustering problems. Pattern Recognition 39, 761–775

S3_5000p_15c			- Fränti, P. and Virmajoki, O. (2006) Iterative shrinking method
				  for clustering problems. Pattern Recognition 39, 761–775

S4_5000p_15c			- Fränti, P. and Virmajoki, O. (2006) Iterative shrinking method
				  for clustering problems. Pattern Recognition 39, 761–775

seeds_210p_7d_3c		- Charytanowicz, M. et al. (2010) Complete gradient clustering
				  algorithm for features analysis of x-ray images. Information
				  Technologies in Biomedicine 69, 15–24

spiral_312p_2d_3c		- Chang H, Yeung DY (2008) Robust path-based 
				  spectral clustering. Pattern Recogn 41:191–203.

easy2_600p_2d_2c		- from this study

transform1_600p_2d_2c		- from this study

transfrom2_600p_2d_2c		- from this study

transform3_600p_2d_2c		- from this study

transform3_600p_2d_2c		- from this study

twoLevel1_504p_2d_9c		- from this study

twoLevel2_700p_2d_9c		- from this study

zacharyTsne_30p_4d_2c		- Zachary, W.W. (1977) An information flow model for conflict 
				  and fission in small groups. Journal of anthropological 
				  research 33, 452–473


==============================================================================
Getting Started
==============================================================================

To run the clusterdv package unzip, change the "KDE" folder name to "@kde" 
and add the folder to the Matlab path. 

The clusterDv.m script opens a user interface and the user should click on 
one of the data sets included in the package or another data set with the 
correct file format: mat file with variable "data" inside, rows are data 
points and columns n dimensions of the data. The algorithm will automatically 
determine the number of clusters and assign each data point to the respective 
group. The groups are saved in the variable 'clusterAssignment' and the index 
of the cluster centers on the variable 'indChoosenClusterCenters'.

==============================================================================
ClusterDv master function
==============================================================================

clusterDvFunction.m (runs ClusterDv)
==============================================================================
important inputs: 

data
clustNumDecision         - select method to calculate number of clusters.
			   It can be: 'SI_jump','onion','simplex', 
			   'all_clusters','square', or 'dendrogram'.
densityType 		 - kde can estimate densities using several methods. 
			   For adaptive Gaussians use 'local'. 
lineDensityMethod	 - line density method. Can be 'slow', 'medium' or 
			   'fast'. It may use Matlab parallel toolbox: 
			   'slowPar','mediumPar', 'fastPar'.
numextra 		 - for the line density method 'medium' or 'mediumPar'
			   defines the degree of extra lines to calculate.
			   Normaly the quare root of the number of points
			   is sufficient. 
nsamps 			 - number of divisions used to calculate density 
			   lines. Often 10 is enough.
multirep 		 - number of reference distribution repetitions.

scalingFactor 		 - factor to scale the density estimation. Put 1
			   for no scaling. 
pointAssignmentMethod 	 - most usual method is 'distance'.
maxNumbOfClusterCenters  - Calculating the dendrogram is computationally costly. 
			   The user should a select a number larger than the 
		           number of clusters that exist in the data set.		         
kdedens 		 - if density kde object was calculated before hand. 
			   If variable is left empty it will be calculated 
			   inside the function.
makeplot 		 - 1 produces plots with clustering results, 0 no plot.

==============================================================================
outputs: 

clusterAssignment	 - vector with cluster assignments. 
			   Each number is a different cluster.		
indChoosenClusterCenters - index of cluster centers selected by clusterDv.
clusterCentersSortedIdx  - index of all points that have SI larger than 0
rho			 - point density.
SImeasure		 - separability index for each point.
SImeasureRandThreshold   - threshold defined by method that selects cluster centers.
tree			 - SI dendrogram.

==============================================================================
Functions that are called by clusterDvFunction.m
==============================================================================

findClusterCentersDensityValley_6.m (determines cluster centers by clusterdv)
==============================================================================
important inputs: 
data
kdedens 		 - if density kde object was calculated before hand. 
			   If variable is left empty it will be calculated 
			   inside the function.
densityType 		 - kde can estimate densities using several methods. 
			   For adaptive Gaussians use 'local'. 
linedensityMethod 	 - line density method. Can be 'slow', 'medium' or 
			   'fast'. It may use Matlab parallel toolbox: 
			   'slowPar','mediumPar', 'fastPar'.
numextra 		 - for the line density method 'medium' or 'mediumPar'
			   defines the degree of extra lines to calculate.
			   Normaly the quare root of the number of points
			   is sufficient. 
nsamps 			 - number of divisions used to calculate density 
			   lines. Often 10 is enough.
multirep 		 - number of reference distribution repetitions.
numbPointsToShow 	 - number of points to show in plot.
clusterThreshold 	 - avoids 'cluster centers' bellow this value.
resampleMethod 		 - methods do make reference distribution. Can be 
			   'onion' or 'simplex'.
scalingFactor 		 - factor to scale the density estimation. Put 1
			   for no scaling. 
makeplot 		 - 1 produces plot, 0 no plot.

makeDendrogramByCenterExclusion_4.m (produces dendrogram according to SI values)
==============================================================================
important inputs: 
data
SImeasure 		 - produced by findClusterCentersDensityValley_6.m. 

decideClusterCentersAll_3.m (decision rule to determine number of clusters)
==============================================================================
important inputs: 
data
SImeasureRandThreshold 	 - SI threshold or outlier density threshold
decisionMethod           - method to decide number of clusters. It can be: 
			   by threshold of reference distributions 
			   ('allClusterCenters'), by clicking in level of 
			   dendrogram ('dendrogram'), by drawing square in 
			   decision plot ('square'), and by picking all cluster
			   centers that have greater density than 
			   SImeasureRandThreshold ('allExcludeOutliers').	

assignDataPointsAllCases_1.m (assigns individual data points to respective clusters)
==============================================================================
important inputs: 
data
pointAssignmentMethod 	 - Most usual method is 'distance'.
