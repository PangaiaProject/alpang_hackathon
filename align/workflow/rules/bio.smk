rule cat_paired_end:
    input:
        fq_1=pjoin(ILLUMINA_DIR, "{sample}_R1.fastq"),
        fq_2=pjoin(ILLUMINA_DIR, "{sample}_R2.fastq"),
    output:
        pjoin(ILLUMINA_DIR, "{sample}.catted.fastq"),
    shell:
        """
        cat {input.fq_1} {input.fq_2} > {output}
        """
