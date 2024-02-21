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

rule panaligner_ont:
    input:
        tool=pjoin(SOFTWARE_DIR, "PanAligner/PanAligner"),
        graph="graph.fixed.minichain.gfa",
        reads=pjoin(ONT_DIR, "{sample}.fastq"),  
    output:
        gaf= pjoin(ONT_ODIR, "panaligner", "{sample}.gaf")
    threads:
        workflow.cores
    shell:
        "{input.tool} -cx lr {input.gfa} {input.reads} > {output.gaf}"

rule panaligner_illumina:
    input:
        tool=pjoin(SOFTWARE_DIR, "PanAligner/PanAligner"),
        graph="graph.fixed.minichain.gfa",
        reads=pjoin(ILLUMINA_DIR, "{sample}.catted.fastq"),
    output:
        gaf= pjoin(ILLUMINA_ODIR, "panaligner", "{sample}.gaf")
    threads:
        workflow.cores
    shell:
        """
        {input.tool} -cx sr {input.gfa} {input.reads} > {output.gaf}
        """
