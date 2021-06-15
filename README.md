# imdik-fichna-onesample

```bash
WD=$PWD
cd $WD
```

1. FastQC - Quality control of \*.fastq files (2 threads) (ifpan-galuszka-aparic)
```bash
docker run --rm -v $WD:/data pegi3s/fastqc -t 2 \
    $(find . -type f -name "*.fq.gz" -exec echo /data/{} \;)
```

2. Generate report with MultiQC (ifpan-galuszka-aparic)
```bash
docker run --rm -v $WD:/data ewels/multiqc:latest /data -o /data
```

3. Aligment (ifpan-marpiech-wgs)
  * read group header line
```
@RG\tID:HVYK2DSXY.2\tPU:HVYK2DSXY.2.onesample\tPL:Illumina\tLB:onesample.library\tSM:onesample
```
  * aligment
```bash
docker run --rm -v $PWD:/data intelliseqngs/bwa-mem-grch38-no-alt:3.1.0 bwa mem \
	-t 6 \
	-R "@RG\tID:HVYK2DSXY.2\tPU:HVYK2DSXY.2.onesample\tPL:Illumina\tLB:onesample.library\tSM:onesample" \
	-K 100000000 \
	-Y \
	/resources/grch38-no-alt-analysis-set.fa \
	/data/a7582/a7582_FDPL210061474-1b_HVYK2DSXY_L2_1.fq.gz \
	/data/a7582/a7582_FDPL210061474-1b_HVYK2DSXY_L2_2.fq.gz \
	-o /data/a7582/onesample-unsorted.sam
```

## Version 1

4. Mark duplicates (ifpan-marpiech-wgs)
```bash
docker run --rm -v $PWD:/data intelliseq/bwa samblaster -i /data/a7582/onesample-unsorted.sam -o /data/a7582/onesample-markdup.sam 2> a7582/onesample-bwa-samblaster-stderr.log
# note: redirecting stderr to a file is outside of a container
```

5. Samtools sort (ifpan-marpiech-wgs)
```bash
docker run --rm -v $PWD:/data intelliseq/bwa samtools sort -o /data/a7582/onesample-markdup-sorted.bam -@ 6 /data/a7582/onesample-markdup.sam
```

6. Remove sam files (ifpan-marpiech-wgs)

7. Make bqsr report (bam-bsqr.wdl)
```bash
RES_PATH=/resources/broad-institute-resources-for-bqsr-and-vqsr/indels-known-sites/ &&
docker container run --rm -v $PWD:/data/ intelliseqngs/task_bam-bsqr:1.1.0 \
gatk --java-options -Xms6000m BaseRecalibrator \
	-R /resources/reference-genomes/broad-institute-hg38/Homo_sapiens_assembly38.fa \
	-I /data/a7582/onesample-markdup-sorted.bam \
	--use-original-qualities \
	-O /data/a7582/onesample_recal-data.csv \
	--known-sites $RES_PATH/Homo_sapiens_assembly38.known_indels.vcf.gz \
	--known-sites $RES_PATH/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz
```

8. Perform bam base quality scores recalibration (bam-base-recalib.wdl)
```bash
docker container run --rm -v $PWD:/data intelliseqngs/gatk-4.1.7.0-hg38:1.0.1 \
gatk --java-options -Xms3000m ApplyBQSR \
	-R /resources/reference-genomes/broad-institute-hg38/Homo_sapiens_assembly38.fa \
	-I /data/a7582/onesample-markdup-sorted.bam \
	-O /data/a7582/onesample_markdup-recalibrated.bam \
	-bqsr /data/a7582/onesample_recal-data.csv \
	--static-quantized-quals 10 \
	--static-quantized-quals 20 \
	--static-quantized-quals 30 \
	--add-output-sam-program-record false \
	--create-output-bam-md5 \
	--use-original-qualities
```
