``` sh
mamba create -c bioconda -c conda-forge -n hack vg samtools bcftools insilicoseq pbsim3
mamba activate hack

wget https://ftp.1000genomes.ebi.ac.uk//vol1/ftp/technical/reference/phase2_reference_assembly_sequence/hs37d5.fa.gz
gunzip hs37d5.fa.gz
samtools faidx hs37d5.fa 21 > 21.fa

wget https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chr21.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz
wget https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chr21.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz.tbi
wget https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/integrated_call_samples_v3.20130502.ALL.panel
grep EUR integrated_call_samples_v3.20130502.ALL.panel | head -64 | cut -f1 > samples.list
bcftools view -c 1 -q 0.01 -Oz -S samples.list  ALL.chr21.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz > 21.vcf.gz
tabix -p vcf 21.vcf.gz
```

``` sh
region="21:39407410-40062514"
mkdir -p $region ; cd $region

SEED=23
cat ../samples.list | (RANDOM=$SEED; while read line ; do echo "$RANDOM $line" ; done ) | sort | cut -f2 -d' ' | head -n 16 > samples.list
bcftools view -Oz -S samples.list ../21.vcf.gz $region > 21.region.vcf.gz
tabix -p vcf 21.region.vcf.gz

vg construct -r ../21.fa -v 21.region.vcf.gz -R $region --alt-paths > graph.vg
vg gbwt --discard-overlaps -v 21.region.vcf.gz -x graph.vg -g graph.gbwtgraph -o graph.gbwt
vg convert -b graph.gbwt graph.gbwtgraph -f -W > graph.wP.gfa
vg mod --unchop graph.wP.gfa > graph.wP.unchopped.gfa

samtools faidx ../21.fa $region > 21.region.fa
samtools faidx 21.region.fa

iss generate --genomes 21.region.fa --model hiseq --n_reads 1000 --cpus 4 --output illumina

pbsim --strategy wgs --prefix ONT --method errhmm --errhmm ../pbsim3/data/ERRHMM-SEQUEL.model --depth 3 --seed 23 --genome 21.region.fa
```