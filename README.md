# imdik-fichna-onesample

```bash
WD=$PWD
cd $WD
```

1. FastQC - Quality control of \*.fastq files (2 threads)
```bash
docker run --rm -v $WD:/data pegi3s/fastqc -t 2 \
    $(find . -type f -name "*.fq.gz" -exec echo /data/{} \;)
```

2. Generate report with MultiQC
```bash
docker run --rm -v $WD:/data ewels/multiqc:latest /data -o /data
```

