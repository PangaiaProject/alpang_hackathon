# Test data

The test data we will use are "random" regions from human chr21.
To keep the graphs as simple as possible, we create them from FASTA+VCF using `vg`.
We will then use `InSilicoSeq` and `pbsim3` to simulate Illumina and ONT reads.

* https://github.com/vgteam/vg
* https://insilicoseq.readthedocs.io/en/latest/
* https://github.com/yukiteruono/pbsim3

### Setup environment
``` sh
mamba create -c bioconda -c conda-forge -n hack vg samtools bcftools insilicoseq pbsim3
mamba activate hack
```

### Setup data
This steps are not necessary. We provide the input for the next steps (i.e., `21.fa`, please gunzip it, `21.vcf.gz`, and `samples.list`)
``` sh
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

### Graph construction and read simulation
``` sh
region="21:39407410-40062514"
SEED=23
nsamples=16

mkdir -p $region
cd $region

# Select 16 random samples from the VCF and extract region of interest
cat ../samples.list | (RANDOM=$SEED; while read line ; do echo "$RANDOM $line" ; done ) | sort | cut -f2 -d' ' | head -n $nsamples > samples.list
bcftools view -Oz -S samples.list ../21.vcf.gz $region > 21.region.vcf.gz
tabix -p vcf 21.region.vcf.gz

# Construct the graph for the region of interest
# adapted from https://github.com/vgteam/vg/issues/3668
# some more info at https://github.com/vgteam/vg/issues/3599#issuecomment-1066911977
vg construct -r ../21.fa -v 21.region.vcf.gz -R $region --alt-paths > graph.vg
# Get the haplotypes and store them in a gbwt and gbwtgrapg
vg gbwt --discard-overlaps -v 21.region.vcf.gz -x graph.vg -g graph.gbwtgraph -o graph.gbwt
# Add the haplotypes to the graph as P lines
vg convert -b graph.gbwt graph.gbwtgraph -f -W > graph.wP.gfa
# Unchop the graph
vg mod --unchop graph.wP.gfa > graph.wP.unchopped.gfa

# Extract region of interest
samtools faidx ../21.fa $region > 21.region.fa
samtools faidx 21.region.fa

# Simulate reads
mkdir illumina
iss generate --seed $SEED --genomes 21.region.fa --model hiseq --n_reads 1000 --cpus 4 --output illumina/reads
mkdir ONT
pbsim --strategy wgs --prefix ONT/reads --method errhmm --errhmm ../pbsim3-model/ERRHMM-ONT.model --depth 3 --seed $SEED --genome 21.region.fa

cd ..
```

Some potential regions of interest:
* `21:14459766-14464736`: ~5kb (provided here)
* `21:43097828-43200841`: ~100kb (provided here)
* `21:29107394-29788049`: ~700kb
* `21:18215829-19914858`: ~1.5Mb
* `21:34407410-40062514`: ~5.5Mb

### Interesting things to do
- [ ] Simulate from a haplotype not in the graph
- [ ] Simulate PacBio CLR and CSS
- [ ] Build/use more complex graphs (e.g., pggb on .msa)
- [ ] Use data from [HPRG](https://github.com/human-pangenomics/hpp_pangenome_resources)
- [ ] How to evaluate alignments?
