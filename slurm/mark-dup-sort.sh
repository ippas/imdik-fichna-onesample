#!/bin/bash

#SBATCH -A plgsportwgs
#SBATCH -p plgrid
#SBATCH -t 1-0:0:0
#SBATCH --mem=18GB
#SBATCH --output=/net/archive/groups/plggneuromol/jhajto/slurm-std/%j.out
#SBATCH --error=/net/archive/groups/plggneuromol/jhajto/slurm-std/%j.err

set -ex

WD=$PLG_GROUPS_SHARED/plggneuromol/jhajto/imdik-fichna-onesample/a7582/
SIF_DIR=$PLG_GROUPS_SHARED/plggneuromol/singularity-images/

cd $WD

srun singularity exec --bind $WD,$SCRATCH $SIF_DIR/gatk-4.1.7.0-hg38_1.0.1.sif \
	sh -c "gatk --java-options '-Xmx14g -Djava.io.tmpdir=$SCRATCH' MarkDuplicates \
		-I a7582_unsorted.bam \
		-O a7582_dup-marked.bam \
		--METRICS_FILE a7582_markdup-metrics.txt \
		--VALIDATION_STRINGENCY SILENT \
		--OPTICAL_DUPLICATE_PIXEL_DISTANCE 2500 \
		--ASSUME_SORT_ORDER 'queryname' \
		--CLEAR_DT false \
		--ADD_PG_TAG_TO_READS false"

srun singularity exec --bind $WD,$SCRATCH $SIF_DIR/gatk-4.1.7.0-hg38_1.0.1.sif \
	sh -c "gatk --java-options '-Xmx15g -Djava.io.tmpdir=$SCRATCH' SortSam \
		-I a7582_dup-marked.bam \
		-O a7582_sorted-dup-marked.bam \
		--SORT_ORDER 'coordinate' \
		--CREATE_INDEX true \
		--CREATE_MD5_FILE true \
		--MAX_RECORDS_IN_RAM 300000"
