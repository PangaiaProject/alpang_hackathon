# --- Minigraph pipeline
# Co-Authored by:
# - Daria Frolova
# - Andreas Rempel
# - et. al


# https://lh3.github.io/minigraph/minigraph.html
# Paired-end mapping is not supported.
rule minigraph_illumina:
    input:
        graph=GFA,
        fa=pjoin(ILLUMINA_DIR, "{sample}.catted.fastq"),
    output:
        gaf= pjoin(ILLUMINA_ODIR, "minigraph", "{sample}.gaf")
    conda:
        "../envs/minigraph.yaml"
    benchmark:
        pjoin(ILLUMINA_ODIR, "minigraph", "{sample}.benchmark.txt")
    log:
        pjoin(ILLUMINA_ODIR, "minigraph", "{sample}.log.txt")
    threads: workflow.cores
    shell:
        """
        minigraph -cx sr -t {threads} {input.graph} {input.fa} > {output.gaf} 2> {log}
        """

rule minigraph_ont:
    input:
        graph=GFA,
        fa=pjoin(ONT_DIR, "{sample}.fastq"),
    output:
        gaf= pjoin(ONT_ODIR, "minigraph", "{sample}.gaf")
    conda:
        "../envs/minigraph.yaml"
    benchmark:
        pjoin(ONT_ODIR, "minigraph", "{sample}.benchmark.txt")
    log:
        pjoin(ONT_ODIR, "minigraph", "{sample}.log.txt")
    threads: workflow.cores
    shell:
        """
        minigraph -cx lr -t {threads} {input.graph} {input.fa} > {output.gaf} 2> {log}
        """
