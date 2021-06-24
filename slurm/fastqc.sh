#!/bin/bash

#SBATCH -A plgsportwgs
#SBATCH -p plgrid
#SBATCH -t 2:0:0
#SBATCH --mem=400MB
#SBATCH --array=1-2%2
#SBATCH --output=/net/archive/groups/plggneuromol/jhajto/slurm-std/%A_%a.out
#SBATCH --error=/net/archive/groups/plggneuromol/jhajto/slurm-std/%A_%a.err

set -ex

WD=$PLG_GROUPS_SHARED/plggneuromol/jhajto/imdik-fichna-onesample/a7582/
SIF_DIR=$PLG_GROUPS_SHARED/plggneuromol/singularity-images/
FASTQ=$(ls $WD/*fq.gz | sed -n ${SLURM_ARRAY_TASK_ID}p) # print p-th line

# LC_ALL=C suppresses perl warnings, LC_ALL is the environment variable that
# overrides all the other localisation settings. The C locale is a special
# locale that is meant to be the simplest locale. You could also say that
# while the other locales are for humans, the C locale is for computers.
srun singularity exec --bind $WD $SIF_DIR/fastqc_v0.11.9_cv8.sif \
	sh -c "LC_ALL=C fastqc $FASTQ"
