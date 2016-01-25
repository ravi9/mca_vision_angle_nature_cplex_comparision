README for nature2ndRev_gridRunner_cplex.

Code Folder: nature2ndRev_gridRunner_cplex
Github URL: https://github.com/ravi9/mca_vision_angle_nature_cplex_comparision

Input Data Folder: Data

The time comparison of magnetic computing versus IBM ILOG CPLEX is performed on the USF CIRCE GRID.

Prerequisites:
1.	IBM ILOG CLPEX must be installed. Students can receive a free version.
a.	Instructions on how to install IBM ILOG CPLEX on Linux machine can be found here: http://www-01.ibm.com/support/docview.wss?uid=swg21444285
2.	Access to CIRCE grid. To request account on CIRCE, see here: http://www.rc.usf.edu/
3.	Knowledge of submitting jobs to CIRCE computing grid. Beginner guide to submit jobs on CIRCE computing grid are available here: https://cwa.rc.usf.edu/projects/research-computing/wiki/Guide_to_Slurm


Assumptions:
Existing code assumes CPLEX is installed at: /work/r/ravi1/EMT/ibm/ILOG/CPLEX_Studio1261/cplex/matlab/x86-64_linux/

If you installed CPLEX at a different location, update the path at line #7 in the file: rp_bashRun2Images.sh

Steps to run the comparison:
1.  To launch experiments with sparsity 96%, run rp_qsubCmds_spars_96.sh
2.  To launch experiments with sparsity 98%, run rp_qsubCmds_spars_98.sh

Execution Workflow:
The dataset (Data) contains 101 images as attribute files (.atts). The submission script (rp_qsubCmds_spars_96.sh) launches 51 jobs. Each job has 2 images as input along with the sparsity value. Each job invokes script rp_bashRun2Images.sh.
The rp_bashRun2Images.sh script is used to submit the job for SLURM(CIRCE grid).
The rp_bashRun2Images.sh script loads Matlab, sets the path to CPLEX and launches the MATLAB script rp_gridMain_Run2Img.m

The Matlab script rp_gridMain_Run2Img.m launches the script: cplexQuadprog_grid2.m, which invokes CPLEX.  The Matlab script cplexQuadprog_grid2.m prepares the affinity matrix and invokes the CPLEX optimization “cplexmiqp”

To summarize, the order of execution workflow:

1.	rp_qsubCmds_spars_98.sh
2.	rp_bashRun2Images.sh
3.	rp_gridMain_Run2Img.m
4.	cplexQuadprog_grid2.m



Description of files:

1.	Intermediate result Folders: grid1-sparse-run1, grid1-run2, grid1_results, grid2_results, cplexgrid2-run2, cplexgrid2-run3, cplexgrid2-run4, cplexgrid2-run5, cplexgrid2-run6, cplexgrid2-run7, cplexgrid2-run8
2.	Data: Contains the dataset. 101 Images in .atts format
3.	rp_qsubCmds_spars_90.sh: Shell script to launch with sparsity 90%
4.	rp_qsubCmds_spars_95.sh: Shell script to launch with sparsity 95%
5.	rp_qsubCmds_spars_96.sh: Shell script to launch with sparsity 96%
6.	rp_qsubCmds_spars_98.sh: Shell script to launch with sparsity 98%
7.	rp_qsubCmds_spars_90_missing.sh: Shell script to rerun missing outputs with sparsity 90%
8.	rp_bashRun2Images.sh: Shell script to submit job to CIRCE grid (SLRUM)
9.	cplexQuadprog_grid1.m: Matlab script version1 which runs CPLEX optimization
10.	cplexQuadprog_grid2.m: Matlab script version2 which runs CPLEX optimization
11.	rp_gridLauncher_100ImgOn50Proc.m: Shell script to generate qsub Commands present in rp_qsubCmds_spars_98.sh
12.	resultAnalyze_cplexgrid.m: Matlab script to analyze the results produced my CPLEX optimization.
13.	resultAnalyze.m: Old Matlab script to analyze results produced from traditional vision.
14.	rp_gridMain_Run2Img.m: Matlab script which calls the cplexQuadprog_grid2.m script
15.	matlabQuadprog.m
16.	cplexQuadprog.m: Matlab script used for testing purposes.
17.	TraditionalVision.m: Matlab scripts which runs traditional vision optimization using Simulated Annealing.
18.	cpuinfo.m: Matlab script which reads the CPU info
19.	plotter.m: Matlab script to plot graphs of the metrics.
20.	Main_driver.m
21.	TraditionalVisionReviewer.m: Matlab scripts which runs traditional vision optimization using Simulated Annealing with slight modification for intial k parameter.
22.	resultAnalyze_tradvizReviewer.m: Matlab script which extracts the time taken, true +ve rate, false +ve rate for running Traditional vision algorithm.
23.	sparsifyWithStrongEdges.m: Matlab script which computes the sparsity of a given Affinity Matrix.
24.	ComputeGroupingAffinities.m: Matlab script which computes the grouping affinities of an image.
25.	AffMatrices: This folder contains all the Affinity Matrices of all images pre-calculated, and used by cplexQuadprog_grid2.m
26.	gridlogs: This folder contains the logs generated while running the jobs.
27.	oldresults: This folder contains the old results
28.	linescount.csv: This excel sheet contains the precomputed information of number of line segments for each image. This information is used in analyzing the results.
29.	FinalCPLEX_graph_avg+std-cplex-96-98.xlsx: Final graph statistics info for CPLEX comparision published in Nature Nano paper
30.	excel_meta: excel sheets which are used to during development of this comparison.

