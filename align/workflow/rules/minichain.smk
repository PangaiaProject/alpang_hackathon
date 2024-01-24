# --- minichain pipeline

rule minichain_install:
    params:
        odir=pjoin(SOFTWARE_DIR, "minichain")
    output:
        pjoin(SOFTWARE_DIR, "minichain/minichain")
    conda:
        "../envs/minichain.yaml"
    shell:
        """
        rm -rf {params.odir}
        git clone https://github.com/at-cg/minichain {params.odir}
        cd {params.odir}
        make
        """

rule minichain_fix_graph:
    input:
        graph=GFA
    output:
        ograph=temp("graph.fixed.minichain.gfa")
    run:
        with open(output.ograph, "w") as out:
            for line in open(input.graph):
                if line.startswith("W"):
                    line = line.strip()
                    _, name, hapix, seqid, seqstart, seqend, walk = line.split()
                    # seqend = 1
                    # seqstart = 1
                    print("W", f"{name}#{hapix}_W", 1, seqid, seqstart, seqend, walk, sep="\t", file=out)
                else:
                    print(line, end="", file=out)

rule minichain_ont:
    input:
        tool=pjoin(SOFTWARE_DIR, "minichain/minichain"),
        graph="graph.fixed.minichain.gfa",
        fa=pjoin(ONT_DIR, "{sample}.fastq"),
    output:
        gaf= pjoin(ONT_ODIR, "minichain", "{sample}.gaf")
    conda:
        "../envs/minichain.yaml"
    benchmark:
        pjoin(ONT_ODIR, "minichain", "{sample}.benchmark.txt")
    log:
        pjoin(ONT_ODIR, "minichain", "{sample}.log.txt")
    threads: workflow.cores
    shell:
        """
        {input.tool} -cx lr -t {threads} {input.graph} {input.fa} > {output.gaf} 2> {log}
        """

rule minichain_illumina:
    input:
        tool=pjoin(SOFTWARE_DIR, "minichain/minichain"),
        graph="graph.fixed.minichain.gfa",
        fa=pjoin(ILLUMINA_DIR, "{sample}.catted.fastq"),
    output:
        gaf= pjoin(ILLUMINA_ODIR, "minichain", "{sample}.gaf")
    conda:
        "../envs/minichain.yaml"
    benchmark:
        pjoin(ILLUMINA_ODIR, "minichain", "{sample}.benchmark.txt")
    log:
        pjoin(ILLUMINA_ODIR, "minichain", "{sample}.log.txt")
    threads: workflow.cores
    shell:
        """
        {input.tool} -cx sr -t {threads} {input.graph} {input.fa} > {output.gaf} 2> {log}
        """
