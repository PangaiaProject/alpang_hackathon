# --- vg-map pipeline
# --- Author: Francesco Andreace

rule index_graph_vg_map:
    input:
        graph = GFA
    output:
        gcsa =  temp(pjoin(ILLUMINA_ODIR, "vg_map", "graph.gcsa")),
        lpc =  temp(pjoin(ILLUMINA_ODIR, "vg_map", "graph.gcsa.lcp")),
        xg =  temp(pjoin(ILLUMINA_ODIR, "vg_map", "graph.xg")),
    conda:
        "../envs/vg.yaml"
    benchmark:
        pjoin(ILLUMINA_ODIR, "vg_map", "graph_building.benchmark.txt")
    log:
        pjoin(ILLUMINA_ODIR, "vg_map", "graph_building.log.txt")
    threads: workflow.cores
    shell:"""
    vg autoindex --workflow map -t {threads} -p {ILLUMINA_ODIR}/vg_map/graph -g {input.graph}
    """

rule vg_map_illumina:
    input:
        gcsa = pjoin(ILLUMINA_ODIR, "vg_map", "graph.gcsa"),
        lpc = pjoin(ILLUMINA_ODIR, "vg_map", "graph.gcsa.lcp"),
        xg = pjoin(ILLUMINA_ODIR, "vg_map", "graph.xg"),
        fq_1 = pjoin(ILLUMINA_DIR, "{sample}_R1.fastq"),
        fq_2 = pjoin(ILLUMINA_DIR, "{sample}_R2.fastq"),
    output:
        gaf = pjoin(ILLUMINA_ODIR, "vg_map", "{sample}.gaf")
    conda:
        "../envs/vg.yaml"
    benchmark:
        pjoin(ILLUMINA_ODIR, "vg_map", "{sample}.benchmark.txt")
    log:
        pjoin(ILLUMINA_ODIR, "vg_map", "{sample}.log.txt")
    threads: workflow.cores
    shell:"""
    vg map -t {threads} -x {input.xg} -g {input.gcsa} -f {input.fq_1} -f {input.fq_2} --gaf > {output.gaf} 2> {log}
    """
