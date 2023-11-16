## SRS121011 
A genomic DNA mixture from 22 bacterial strains containing equimolar (Even) ribosomal RNA operon counts per organism. 
Pooled DNA from the organisms listed below at approximately even concentrations of genomic DNA concentrations. 
This mock microbiome community was designed to test HMP sequencing protocols and analysis. 
Organism (strain#)-Target 16S copies in PCR: 
Acinetobacter baumanii (ATCC 17978)-100000, Actinomyces odontolyticus (ATCC 17982)-100000, 
Bacillus cereus (ATCC 10987)-100000, Bacteroides vulgatus (ATCC 8482)-100000, 
Candida albicans (SC5314)-1120, Clostridium beijerinckii (ATCC 51743)-100000, 
Deinococcus radiodurans (DSM 20539)-100000, Enterococcus faecalis (ATCC 47077)-100000, 
Escherichia coli (ATCC 70096)-100000, Helicobacter pylori (ATCC 700392)-100000, Lactobacillus gasseri (DSM 20243)-100000, 
Listeria monocytogenes (ATCC BAA-679)-100000, Methanobrevibacter smithii (ATCC 35061)-100000, 
Neisseria meningitidis (ATCC BAA-335)-100000, Propionibacterium acnes (DSM 16379)-100000, 
Pseudomonas aeruginosa (ATCC 47085)-100000, Rhodobacter sphaeroides (ATCC 17023)-100000, 
Staphylococcus aureus (ATCC BAA-1718)-100000, Staphylococcus epidermidis (ATCC 12228)-100000, 
Streptococcus agalactiae (ATCC BAA-611)-100000, Streptococcus mutans (ATCC 700610)-100000, 
Streptococcus pneumoniae (ATCC BAA-334)-100000.

https://www.ebi.ac.uk/metagenomics/studies/MGYS00000300#overview


## Read simulation

InSilicoSeq HiSeq reads
```
iss generate --genomes SRS121011.fasta --model hiseq --n_reads 1000 --cpus 8 --output data/reads.iss
```

## Graph construction

VG
```
vg construct -M SRS121011.fasta -t 16 -A | vg view - > data/graph.gfa
vg mod --unchop data/graph.gfa > data/graph.unchopped.gfa
```
