# ALPACA/PANGAIA ANNUAL WORKSHOP - Hackathon
Sequence to graph aligner evaluation

## Aligners
### `vg` [![Align - pass](https://img.shields.io/badge/Align-pass-2ea44f)](#)

Relevant links:
- https://github.com/vgteam/vg
- map: https://www.nature.com/articles/nbt.4227#Abs2
- giraffe: https://www.science.org/doi/full/10.1126/science.abg8871

### `GraphAligner` [![Align - pass](https://img.shields.io/badge/Align-pass-2ea44f)](#)

Relevant links:
- https://github.com/maickrau/GraphAligner
- https://genomebiology.biomedcentral.com/articles/10.1186/s13059-020-02157-2

### `minigraph` [![Align - pass](https://img.shields.io/badge/Align-pass-2ea44f)](#)
Relevant links:
- https://github.com/lh3/minigraph
- https://link.springer.com/article/10.1186/s13059-020-02168-z

### `GraphChainer` [![Align - pass](https://img.shields.io/badge/Align-pass-2ea44f)](#)
Relevant links:
- https://github.com/algbio/GraphChainer
- https://academic.oup.com/bioinformatics/article/39/8/btad460/7231478

### `minichain` [![Align - pass](https://img.shields.io/badge/Align-pass-2ea44f)](#)
Relevant links:
- https://github.com/at-cg/minichain
- https://link.springer.com/chapter/10.1007/978-3-031-29119-7_4

### `PanAligner` [![Align - pass](https://img.shields.io/badge/Align-pass-2ea44f)](#)
Relevant links:
- https://github.com/at-cg/PanAligner
- https://www.biorxiv.org/content/10.1101/2023.06.21.545871v1.abstract

### `PaSGAL` [![Align - investigation](https://img.shields.io/badge/Align-investigation-yellow)](#)
**Reasons for investigation**:
- Output format is not canonical `gaf`/`gam`, investigation is needed to see if
a conversion is feasible

Relevant links:
- https://github.com/ParBLiSS/PaSGAL
- https://doi.org/10.1109/IPDPS.2019.00055

### `V-Align` [![Align - investigation](https://img.shields.io/badge/Align-investigation-yellow)](#)
**Reasons for investigation**:
- The instructions are not clear
- It may have everything it needs to run it
- It is not clear what are inputs and outputs formats

Relevant links:
- https://github.com/tcsatc/V-ALIGN
- https://www.liebertpub.com/doi/abs/10.1089/cmb.2017.0264

### `Vargas` [![Align - fail](https://img.shields.io/badge/Align-fail-red)](#)

**Reasons for failure**:
- It needs a specific graph format as input, that **must** be constructed with `vargas define`
- It is not possible to convert `gfa`/`vg` to such format
- It is thus impossible to fairly compare with other methods

Relevant links:
- https://github.com/langmead-lab/vargas
- https://academic.oup.com/bioinformatics/article/36/12/3712/5823884

### `HGA` [![Align - fail](https://img.shields.io/badge/Align-fail-red)](#)
**Reasons for failure**:
- It need its proprietary input format, for which the only *"documentation"* is in https://github.com/RapidsAtHKUST/hga/issues/1 
- It is not possible to convert `gfa`/`vg` to such format
- The output format is not specified, and it is currently impossible to run the tool
- It is thus impossible to fairly compare with other methods

Relevant links:
- https://github.com/RapidsAtHKUST/hga
- https://doi.org/10.1145/3472456.3472505

### `ASTARIX2` [![Align - fail](https://img.shields.io/badge/Align-fail-red)](#)

- The output format is a TSV and doesn't have a `gaf`/`gam` conversion.
- It may be possible to have a conversion tool, but the task is not trivial 
and the authors are not progressing on it, see https://github.com/eth-sri/astarix/issues/3

Relevant links:
- https://github.com/eth-sri/astarix
- https://link.springer.com/chapter/10.1007/978-3-031-04749-7_22
- https://link.springer.com/chapter/10.1007/978-3-030-45257-5_7
    
### `SeGram` [![Align - fail](https://img.shields.io/badge/Align-fail-red)](#)
**Reasons for failure**:
- There is no implementation of CLI
- Using the tool requires manual changes to the source code to use desired input
- An initial seed for the alignment is required to be specified manual
- The output format is not specified, and it is currently impossible to run the tool
- It is thus impossible to fairly compare with other methods

Relevant links:
- https://github.com/CMU-SAFARI/SeGraM
- https://people.inf.ethz.ch/omutlu/pub/SeGraM_genomic-sequence-mapping-universal-accelerator_isca22.pdf