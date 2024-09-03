#Pipeline to generate a linear reference genome

rule generateLinearReference:
    input:
        reference = config["referenceSequence"],
        variants = config["own"]["vcfFile"]
    output:
        pjoin(OWN_SCRIPT_DIR, "extracted_genome_sequences", "{sample}#{haplotype}.fa")
    shell:
        """
        bcftools consensus -f {input.reference} -H $(({wildcards.haplotype}+1)) -s {wildcards.sample} {input.variants} > {output}
        sed -i '/^>/c\\>  {wildcards.sample}#{wildcards.haplotype}' {output}
        """
