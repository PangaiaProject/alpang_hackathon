# --- GraphAligner pipeline
# Co-Authored by:
# - Jorge Avila Cartes
# - Khodor Hanush


rule graph_aligner_illumina:
    input:
        graph=GFA,
        reads1=pjoin(ILLUMINA_DIR, "{sample}_R1.fastq"),
        reads2=pjoin(ILLUMINA_DIR, "{sample}_R1.fastq"),
    output:
        gaf=pjoin(ILLUMINA_ODIR, "graph_aligner", "{sample}.gaf"),
    threads: workflow.cores
    log:
        pjoin(ILLUMINA_ODIR, "graph_aligner", "{sample}.log.txt"),
    conda:
        "../envs/graphaligner.yaml"
    shell:
        """
        GraphAligner -g {input.graph} -f {input.reads1} {input.reads2} -x vg -a {output.gaf} -t {threads}
        """


rule graph_aligner_ont:
    input:
        graph=GFA,
        reads=pjoin(ONT_DIR, "{sample}.fastq"),
    output:
        gaf=pjoin(ONT_ODIR, "graph_aligner", "{sample}.gaf"),
    threads: workflow.cores
    log:
        pjoin(ONT_ODIR, "graph_aligner", "{sample}.log.txt"),
    conda:
        "../envs/graphaligner.yaml"
    shell:
        """
        GraphAligner -g {input.graph} -f {input.reads} -x vg -a {output.gaf} -t {threads}
        """

rule graph_aligner_ownScript:
    input:
        graph=GFA,
        reads = pjoin(OWN_SCRIPT_DIR, "simulated_read_sequences", "{haplotype}.testReads.fa")
    output:
        pjoin(OWN_SCRIPT_ODIR, "sequence_to_graph_mappings", "graph_aligner", "{haplotype}.testReads.gaf")
    threads: workflow.cores
    log:
        pjoin(OWN_SCRIPT_ODIR, "graph_aligner", "{haplotype}.log.txt"),
    conda:
        "../envs/graphaligner.yaml"
    benchmark:
        pjoin(OWN_SCRIPT_ODIR, "graph_aligner", "{haplotype}.benchmark.txt")
    shell:
        """
        GraphAligner -g {input.graph} -f {input.reads} -x vg -a {output} -t {threads} > {log}
        """
