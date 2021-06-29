#!/bin/bash

#SBATCH -A plgsportwgs
#SBATCH -p plgrid
#SBATCH -t 1-0:0:0
#SBATCH --mem=10GB
#SBATCH --output=/net/archive/groups/plggneuromol/jhajto/slurm-std/%j.out
#SBATCH --error=/net/archive/groups/plggneuromol/jhajto/slurm-std/%j.err

set -ex

WD=$PLG_GROUPS_SHARED/plggneuromol/jhajto/imdik-fichna-onesample/a7582/
SIF_DIR=$PLG_GROUPS_SHARED/plggneuromol/singularity-images/

cd $WD

srun singularity exec --bind $WD,$SCRATCH $SIF_DIR/gatk-4.1.7.0-hg38_1.0.1.sif \
	gatk --java-options "-Xms3000m -Djava.io.tmpdir=$SCRATCH" ApplyBQSR \
		-R /resources/reference-genomes/broad-institute-hg38/Homo_sapiens_assembly38.fa \
		-I a7582_sorted-dup-marked.bam \
		-O a7582_markdup-recalibrated.bam \
		-bqsr a7582_recal-data.csv \
		--static-quantized-quals 10 \
		--static-quantized-quals 20 \
		--static-quantized-quals 30 \
		--add-output-sam-program-record false \
		--create-output-bam-md5 \
		--use-original-qualities
