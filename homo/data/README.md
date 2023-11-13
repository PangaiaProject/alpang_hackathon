## Reference

Chr21 `hs37d5.fa` subsampled to (random) region 21:34407410-40062514 [ftp](https://ftp.1000genomes.ebi.ac.uk//vol1/ftp/technical/reference/phase2_reference_assembly_sequence/hs37d5.fa.gz)

VCF is a 5k random rows subsample of 1000 genomes phase 3 VCF [ftp](https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chr21.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz)

## Read generation
InSilicoSeq HiSeq reads
```
iss generate --genomes 21.sub.fa --model hiseq --n_reads 1000 --cpus 8 --output data/reads.iss
```

## Graph construction
VG
```
vg construct -r 21.sub.fa -v 21.phase3.sub.5k.vcf.gz -A | vg view - > data/graph.gfa
vg mod --unchop data/graph.gfa > data/graph.unchopped.gfa
```
