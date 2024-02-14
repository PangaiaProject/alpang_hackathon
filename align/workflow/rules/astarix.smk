rule astarix_install:
    params:
        odir=pjoin(SOFTWARE_DIR, "astarix")
    output:
        pjoin(SOFTWARE_DIR, "astarix/release/astarix")
    conda:
        "envs/astarix.yaml"
    shell:
        """
        rm -rf {params.odir}
        git clone https://github.com/eth-sri/astarix.git {params.odir}
        cd {params.odir} 
        cpp --version
        git submodule update --init --recursive
        cpp --version
        make
        """


rule astarix_illumina:
    input:
        tool=pjoin(SOFTWARE_DIR, "astarix/release/astarix"),
        fa=pjoin(ILLUMINA_DIR, "{sample}.catted.fastq"),
        graph=GFA,
    output:
        real= pjoin(ILLUMINA_ODIR, "astarix",'{sample}.tsv')
    benchmark:
        pjoin(ILLUMINA_ODIR, "astarix", "{sample}.benchmark.txt")
    log:
        pjoin(ILLUMINA_ODIR, "astarix", "{sample}.log.txt")
    conda:
        "envs/astarix.yaml"
    params:
        fixed_trie_depth=1,
        seeds_len=25,
        folder=pjoin(ILLUMINA_ODIR, "astarix"),
    threads: workflow.cores
    shell:
        """
        {input.tool} align-optimal -a astar-seeds -t {threads} -v 1 -g {input.graph} -q {input.fa} -o {params.folder} --fixed_trie_depth {params.fixed_trie_depth} --seeds_len {params.seeds_len};
        mv {params.folder}/alignments.tsv {output.real}
        """

rule astarix_ONT:
    input:
        tool=pjoin(SOFTWARE_DIR, "astarix/release/astarix"),
        fa=pjoin(ONT_DIR, "{sample}.catted.fastq"),
        graph=GFA,
    output:
        real= pjoin(ONT_ODIR "astarix",'{sample}.tsv')
    benchmark:
        pjoin(ONT_ODIR, "astarix", "{sample}.benchmark.txt")
    log:
        pjoin(ONT_ODIR, "astarix", "{sample}.log.txt")
    conda:
        "envs/astarix.yaml"
    params:
        fixed_trie_depth=1,
        seeds_len=25,
        folder=pjoin(ONT_ODIR, "astarix"),
    threads: workflow.cores
    shell:
        """
        {input.tool} align-optimal -a astar-seeds -t {threads} -v 1 -g {input.graph} -q {input.fa} -o {params.folder} --fixed_trie_depth {params.fixed_trie_depth} --seeds_len {params.seeds_len};
        mv {params.folder}/alignments.tsv {output.real}