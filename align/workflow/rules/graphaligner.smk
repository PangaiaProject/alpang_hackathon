# --- GraphAligner pipeline
# Co-Authored by:
# - Jorge Avila Cartes
# - Khodor Hanush

from pathlib import Path
from os.path import join as pjoin

THREADS = config["threads"]["graph_aligner"]

rule graph_aligner_illumina:
    input:
        graph=GFA,#pjoin( ILLUMINA_DIR, "{gfa}.gfa"),
        reads1=pjoin( ILLUMINA_DIR, "{reads}_R1.fastq"),
        reads2=pjoin( ILLUMINA_DIR, "{reads}_R1.fastq"),
    output:
        gam=pjoin( ILLUMINA_ODIR,"graph_aligner","{reads}.gam")
    threads:
        THREADS
    conda:
        "envs/graphaligner.yml"
    shell:
        "GraphAligner -g {input.graph} -f {input.reads1} {input.reads2} -x vg -a {output.gam} -t {threads}"

rule graph_aligner_ont:
    input:
        graph=GFA,#pjoin( ONT_DIR, "{gfa}.gfa"),
        reads=pjoin( ONT_DIR, "{reads}.fastq")
    output:
        gam=pjoin( ONT_ODIR,"graph_aligner","{reads}.gam")
    threads:
        THREADS
    conda:
        "envs/graphaligner.yml"
    shell:
        "GraphAligner -g {input.graph} -f {input.reads} -x vg -a {output.gam} -t {threads}"