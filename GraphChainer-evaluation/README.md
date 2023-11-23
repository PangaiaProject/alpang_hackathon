# GraphChainer evaluation

## Basic information

- I/O seems standard enough
  - Input:
    - reads:  .fasta / .fastq / .fasta.gz / .fastq.gz
    - graph: VGA/VG
  - Output: GAM
- Graph needs to be acyclic
  - suggested pipeline using vg tool to create acyclic graph
- "Do embedded paths affect the alignment?"
  - TODO
- "is it for short/long reads? Paired-end or single-end?"
  - long single reads, apparently high error rate is OK

  