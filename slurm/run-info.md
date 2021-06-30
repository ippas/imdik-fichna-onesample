1. `fastqc`  
   Pliki:
```
24G a7582_FDPL210061474-1b_HVYK2DSXY_L2_2.fq.gz
23G a7582_FDPL210061474-1b_HVYK2DSXY_L2_1.fq.gz
```
   Podsumowanie zadania:
```
ID               Name    Partition   Nodes   Cores   Decl._mem   Mem._%_usage    Eff.   CPU._used   Wall._Used
--               ----    ---------   -----   -----   ---------   ------------    ----   ---------   ----------
57097992_1  fastqc.sh       plgrid       1       1    400.0MiB          75.0%   99.0%    01:06:24     01:06:24
57097992_2  fastqc.sh       plgrid       1       1    400.0MiB          75.0%   98.9%    01:07:19     01:07:19
```

Zadanie było uruchomione w osobnych zadaniach (dwóch, niezależnych). Obliczenia zajęły trochę ponad godzinę i potrzebowały ~300MB pamięci.

2. `bwa mem`  
   Wejściem jest para plików `fq`. Zadanie uruchomione na 12 rdzeniach. Zajęło niecałe 8:30h i potrzebowało ~8GB pamięci.
```
ID               Name   Partition   Nodes   Cores   Decl._mem   Mem._%_usage    Eff.    CPU._used   Wall._Used
--               ----   ---------   -----   -----   ---------   ------------    ----    ---------   ----------
57142124   bwa-mem.sh      plgrid       1      12     12.0GiB          65.8%   98.5%   4-04:19:24     08:21:37
```

3. MarkDuplicates, SortSam
   Zadanie uruchomione na jedym wątku. Ze względu na ograniczoną pojemność folderu `tmp`, zadanie bardzo szybko
   kończyło się błędem. Należało ustawić katalog tymczasowy dla javy: `-Djava.io.tmpdir=$SCRATCH`.

   Zasadniczo nie ma powodu dla którego uruchamiam komendę za pomocą `sh -c "gatk ..."`, a nie po prostu `gatk ...`. Należy jednak uważać na odpowiedni cudzysłów.
```
ID                     Name   Partition   Nodes   Cores   Decl._mem   Mem._%_usage    Eff.   CPU._used   Wall._Used
--                     ----   ---------   -----   -----   ---------   ------------    ----   ---------   ----------
57337019   mark-dup-sort.sh      plgrid       1       1     18.0GiB          77.0%   73.3%    11:37:06     11:37:06
```

4. BQSR report
   Użyty w tym zadaniu obraz dockera przekształcony na obraz singularity nie miał uprawinień do odczytu przez _innych_ dla folderu `resources`. Dlatego wszystkie pliki wejściowe wczytuję z dysku.
```
ID                   Name   Partition   Nodes   Cores   Decl._mem   Mem._%_usage    Eff.   CPU._used   Wall._Used
--                   ----   ---------   -----   -----   ---------   ------------    ----   ---------   ----------
57442954   bqsr-report.sh      plgrid       1       1     10.0GiB          20.1%   99.8%    03:16:35     03:16:35
```

5. Apply BQSR
```
ID                  Name   Partition   Nodes   Cores   Decl._mem   Mem._%_usage    Eff.   CPU._used   Wall._Used
--                  ----   ---------   -----   -----   ---------   ------------    ----   ---------   ----------
57448740   apply-bqsr.sh      plgrid       1       1     10.0GiB          10.5%   99.8%    04:53:27     04:53:27
```
