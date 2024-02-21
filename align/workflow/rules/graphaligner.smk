# --- GraphAligner pipeline
# Co-Authored by:
# - Jorge Avila Cartes
# - Khodor Hanush

rule graph_aligner_illumina:
    input:
        graph=GFA,#pjoin( ILLUMINA_DIR, "{gfa}.gfa"),
        reads1=pjoin( ILLUMINA_DIR, "{reads}_R1.fastq"),
        reads2=pjoin( ILLUMINA_DIR, "{reads}_R1.fastq"),
    output:
        gaf=pjoin( ILLUMINA_ODIR,"graph_aligner","{reads}.gaf")
    threads: 
        workflow.cores    
    conda:
        "../envs/graphaligner.yaml"
    shell:
        """
        GraphAligner -g {input.graph} -f {input.reads1} {input.reads2} -x vg -a {output.gaf} -t {threads}
        """

rule graph_aligner_ont:
    input:
        graph=GFA,#pjoin( ONT_DIR, "{gfa}.gfa"),
        reads=pjoin( ONT_DIR, "{reads}.fastq")
    output:
        gaf=pjoin( ONT_ODIR,"graph_aligner","{reads}.gaf")
    threads:
        workflow.cores
    conda:
        "../envs/graphaligner.yaml"
    shell:
        """
        GraphAligner -g {input.graph} -f {input.reads} -x vg -a {output.gaf} -t {threads}
        """