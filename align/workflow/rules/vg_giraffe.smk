# --- vg-giraffe pipeline
# --- AUTHOR: Francesco Andreace

rule index_graph_vg_giraffe:
    input:
        graph=GFA
    output:
        gbz= pjoin(GRAPH_DIR, "vg_giraffe", "graph.giraffe.gbz"),
        dist= pjoin(GRAPH_DIR, "vg_giraffe", "graph.dist"),
        minimizers= pjoin(GRAPH_DIR, "vg_giraffe", "graph.min"),
    conda:
        "../envs/vg.yaml"
    benchmark:
        pjoin(GRAPH_DIR, "vg_giraffe", "graph_building.benchmark.txt"),
    log:
        pjoin(GRAPH_DIR, "vg_giraffe", "graph_building.log.txt"),
    threads: workflow.cores
    shell:"""
    vg autoindex --workflow giraffe -t {threads} -p {GRAPH_DIR}/vg_giraffe/graph -g {input.graph}
    """

rule vg_giraffe_illumina:
    input:
        gbz= pjoin(GRAPH_DIR, "vg_giraffe", "graph.giraffe.gbz"),
        dist= pjoin(GRAPH_DIR, "vg_giraffe", "graph.dist"),
        minimizers= pjoin(GRAPH_DIR, "vg_giraffe", "graph.min"),
        fq_1=pjoin(ILLUMINA_DIR, "{sample}_R1.fastq"),
        fq_2=pjoin(ILLUMINA_DIR, "{sample}_R2.fastq"),
    output:
        gaf= pjoin(ILLUMINA_ODIR, "vg_giraffe", "{sample}.gaf")
    conda:
        "../envs/vg.yaml"
    benchmark:
        pjoin(ILLUMINA_ODIR, "vg_giraffe", "{sample}.benchmark.txt")
    log:
        pjoin(ILLUMINA_ODIR, "vg_giraffe", "{sample}.log.txt")
    threads: workflow.cores
    shell:"""
    vg giraffe -t {threads} -Z {input.gbz} -m {input.minimizers} -d {input.dist} -f {input.fq_1} -f {input.fq_2} -o gaf > {output.gaf} 2> {log}
    """


