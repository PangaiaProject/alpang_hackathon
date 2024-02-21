# --- PanAligner pipeline
# Co-Authored by:
# - Alessia Petescia
# - Jorge Avila Cartes

from pathlib import Path 
Path(SOFTWARE_DIR).mkdir(parents=True, exist_ok=True)

rule panaligner_install:
    params:
        software_dir=SOFTWARE_DIR
    output:
        pjoin(SOFTWARE_DIR, "PanAligner/PanAligner")
    conda:
        "../envs/panaligner.yaml"
    shell:
        """
        cd {params.software_dir}
        git clone https://github.com/at-cg/PanAligner
        cd PanAligner && make
        """

rule panaligner_ont:
    input:
        tool=pjoin(SOFTWARE_DIR, "PanAligner/PanAligner"),
        graph="graph.fixed.minichain.gfa",
        reads=pjoin(ONT_DIR, "{sample}.fastq"),  
    output:
        gaf= pjoin(ONT_ODIR, "panaligner", "{sample}.gaf")
    threads:
        workflow.cores
    conda:
        "../envs/panaligner.yaml"
    log:
        pjoin(ONT_ODIR, "panaligner", "{sample}.log.txt")
    shell:
        """
        {input.tool} -cx lr {input.graph} {input.reads} > {output.gaf} 2> {log}
        """

rule panaligner_illumina:
    input:
        tool=pjoin(SOFTWARE_DIR, "PanAligner/PanAligner"),
        graph="graph.fixed.minichain.gfa",
        reads=pjoin(ILLUMINA_DIR, "{sample}.catted.fastq"),
    output:
        gaf= pjoin(ILLUMINA_ODIR, "panaligner", "{sample}.gaf")
    threads:
        workflow.cores
    conda:
        "../envs/panaligner.yaml"
    log:
        pjoin(ILLUMINA_ODIR, "panaligner", "{sample}.log.txt")
    shell:
        """
        {input.tool} -cx sr {input.graph} {input.reads} > {output.gaf} 2> {log}
        """
