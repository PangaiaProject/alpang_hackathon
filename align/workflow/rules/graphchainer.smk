# --- Graphchainer pipeline
# Co-Authored by:
# - Askar Gafurov
# - Mattia Sgrò
# - Brian Riccardi

rule graphchainer_install:
    params:
        odir=pjoin(SOFTWARE_DIR, "GraphChainer")
    output:
        pjoin(SOFTWARE_DIR, "GraphChainer/bin/GraphChainer")
    conda:
        "../envs/graphchainer.yaml"
    shell:
        """
        rm -rf {params.odir}
        git clone https://github.com/algbio/GraphChainer.git {params.odir}
        cd {params.odir}
        git submodule update --init --recursive
        make bin/GraphChainer
        """

rule graphchainer_illumina:
    input:
        tool=pjoin(SOFTWARE_DIR, "GraphChainer/bin/GraphChainer"),
        fa=pjoin(ILLUMINA_DIR, "{sample}.catted.fastq"),
        graph=GFA,
    output:
        gam= pjoin(ILLUMINA_ODIR, "graphchainer", "{sample}.gam")
    benchmark:
        pjoin(ILLUMINA_ODIR, "graphchainer", "{sample}.benchmark.txt")
    log:
        pjoin(ONT_ODIR, "graphchainer", "{sample}.log.txt")
    conda:
        "../envs/graphchainer.yaml"
    params:
        sampling_step=1,
        colinear_split_len=35,
        colinear_gap=35,
    threads: workflow.cores
    shell:
        """
        {input.tool} -t {threads} \
            --sampling-step {params.sampling_step} \
            --colinear-split-len {params.colinear_split_len} \
            --colinear-gap {params.colinear_gap} \
            -f {input.fa} -g {input.graph} -a {output.gam} &> {log}
        """

rule graphchainer_ont:
    input:
        tool=pjoin(SOFTWARE_DIR, "GraphChainer/bin/GraphChainer"),
        fa=pjoin(ONT_DIR, "{sample}.fastq"),
        graph=GFA,
    output:
        gam= pjoin(ONT_ODIR, "graphchainer", "{sample}.gam")
    benchmark:
        pjoin(ONT_ODIR, "graphchainer", "{sample}.benchmark.txt")
    log:
        pjoin(ONT_ODIR, "graphchainer", "{sample}.log.txt")
    conda:
        "../envs/graphchainer.yaml"
    params:
        sampling_step=1,
        colinear_split_len=35,
        colinear_gap=35,
    threads: workflow.cores
    shell:
        """
        {input.tool} -t {threads} \
            --sampling-step {params.sampling_step} \
            --colinear-split-len {params.colinear_split_len} \
            --colinear-gap {params.colinear_gap} \
            -f {input.fa} -g {input.graph} -a {output.gam} &> {log}
        """
