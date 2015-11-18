#!/bin/bash
#SBATCH --job-name=matlab_MCAVision_nat2
#SBATCH --time=02:00:00
#SBATCH --output=gridlogs/output.%j.log

module load apps/matlab/r2013b
matlab -nodisplay -r "userpath('/work/r/ravi1/EMT/ibm/ILOG/CPLEX_Studio1261/cplex/matlab/x86-64_linux/')"
matlab -nodisplay -r "rp_gridMain_Run2Img('$1','$2',$3)" 
