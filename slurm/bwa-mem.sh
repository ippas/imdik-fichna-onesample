#!/bin/bash

#SBATCH -A plgsportwgs
#SBATCH -p plgrid
#SBATCH -t 1-0:0:0
#SBATCH --cpus-per-task=12
#SBATCH --mem=8GB
#SBATCH --output=/net/archive/groups/plggneuromol/jhajto/slurm-std/%j.out
#SBATCH --error=/net/archive/groups/plggneuromol/jhajto/slurm-std/%j.err

set -ex

WD=$PLG_GROUPS_SHARED/plggneuromol/jhajto/imdik-fichna-onesample/a7582/
SIF_DIR=$PLG_GROUPS_SHARED/plggneuromol/singularity-images/
FASTQ_1=$(ls $WD/*fq.gz | sed -n 1p)  # print 1-th line
FASTQ_2=$(ls $WD/*fq.gz | sed -n 2p)  # print 2-th line

srun singularity exec --bind $WD $SIF_DIR/bwa-mem-grch38-no-alt_3.1.0.sif sh -c "bwa mem \
    -t 12 \
    -R '@RG\tID:HVYK2DSXY.2\tPU:HVYK2DSXY.2.a7582\tPL:Illumina\tLB:a7582.library\tSM:a7582' \
    -K 100000000 \
    -Y \
    /resources/grch38-no-alt-analysis-set.fa \
    $FASTQ_1 \
    $FASTQ_2 \
    | bgzip > $WD/a7582_unsorted.bam"
