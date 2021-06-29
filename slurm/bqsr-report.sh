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

RES_PATH=$PLG_GROUPS_SHARED/plggneuromol/jhajto/ref-gen/
RES_PATH_HG=$RES_PATH/broad-institute-hg38
RES_PATH_IND=$RES_PATH/broad-institute-resources-for-bqsr-and-vqsr/indels-known-sites

srun singularity exec --bind $WD,$SCRATCH,$RES_PATH $SIF_DIR/task_bam-bsqr_1.1.0.sif \
	sh -c "gatk --java-options '-Xms6000m -Djava.io.tmpdir=$SCRATCH' BaseRecalibrator \
		-R $RES_PATH_HG/Homo_sapiens_assembly38.fa \
		-I a7582_sorted-dup-marked.bam \
		--use-original-qualities \
		-O a7582_recal-data.csv \
		--known-sites $RES_PATH_IND/Homo_sapiens_assembly38.known_indels.vcf.gz \
		--known-sites $RES_PATH_IND/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz"
