# GraphChainer evaluation

## Basic information about GraphChainer

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

## Additional notes

- on parameters:
  - `--sampling-step` controls the trade-off between precision and speed
  - `--colinear-split-len` controls the anchor size, in which an input long read is split into
    - so, longer splits give better specificity, but lower sensitivity
  - `--colinear-split-gap` is dependent on `--colinear-split-len`, so it can be **ignored** for now
  - `--colinear-gap` controls whether to split long alignments into shorter ones, if adjacent anchors are too far

## Install the tool

```bash
source install_grapphchainer.sh
```

Creates `GraphChainer` conda environment, which is then used in the Snakemake pipeline.