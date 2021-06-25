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
