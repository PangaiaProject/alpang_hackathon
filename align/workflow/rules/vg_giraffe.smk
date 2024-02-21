# --- vg-giraffe pipeline
# --- Author: Francesco Andreace


rule index_graph_vg_giraffe:
    input:
        graph=GFA,
    output:
        gbz=temp(pjoin(ILLUMINA_ODIR, "vg_giraffe", "graph.giraffe.gbz")),
        dist=temp(pjoin(ILLUMINA_ODIR, "vg_giraffe", "graph.dist")),
        minimizers=temp(pjoin(ILLUMINA_ODIR, "vg_giraffe", "graph.min")),
    conda:
        "../envs/vg.yaml"
    benchmark:
        pjoin(ILLUMINA_ODIR, "vg_giraffe", "graph_building.benchmark.txt")
    log:
        pjoin(ILLUMINA_ODIR, "vg_giraffe", "graph_building.log.txt"),
    threads: workflow.cores
    shell:
        """
        vg autoindex --workflow giraffe -t {threads} -p {ILLUMINA_ODIR}/vg_giraffe/graph -g {input.graph}
        """


rule vg_giraffe_illumina:
    input:
        gbz=pjoin(ILLUMINA_ODIR, "vg_giraffe", "graph.giraffe.gbz"),
        dist=pjoin(ILLUMINA_ODIR, "vg_giraffe", "graph.dist"),
        minimizers=pjoin(ILLUMINA_ODIR, "vg_giraffe", "graph.min"),
        fq_1=pjoin(ILLUMINA_DIR, "{sample}_R1.fastq"),
        fq_2=pjoin(ILLUMINA_DIR, "{sample}_R2.fastq"),
    output:
        gaf=pjoin(ILLUMINA_ODIR, "vg_giraffe", "{sample}.gaf"),
    conda:
        "../envs/vg.yaml"
    benchmark:
        pjoin(ILLUMINA_ODIR, "vg_giraffe", "{sample}.benchmark.txt")
    log:
        pjoin(ILLUMINA_ODIR, "vg_giraffe", "{sample}.log.txt"),
    threads: workflow.cores
    params:
        max_frag_len=config["vg_giraffe"]["m_frag_len"],
    shell:
        """
        vg giraffe -t {threads} --max-fragment-length {params.max_frag_len} -Z {input.gbz} -m {input.minimizers} -d {input.dist} -f {input.fq_1} -f {input.fq_2} -o gaf > {output.gaf} 2> {log}
        """
