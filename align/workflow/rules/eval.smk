# Read mapping evaluation pipeline

rule evaluateMappings:
    input:
        mappings = expand(pjoin(OWN_SCRIPT_ODIR, "sequence_to_graph_mappings", "{t}", "{h}.testReads.gaf"), t="{tool}", h=HAPLO_NAMES),
        graph = GFA,
        reads = expand(pjoin(OWN_SCRIPT_DIR, "simulated_read_sequences", "{h}.testReads.fa"), h=HAPLO_NAMES)
    params:
        "{minOverlap}"
    output:
        res = pjoin(OWN_SCRIPT_ODIR, "{tool}", "evaluationResults_minOv{minOverlap}.txt"),
        log = pjoin(OWN_SCRIPT_ODIR, "{tool}", "evaluationResults_minOv{minOverlap}.log")
    shell:
        """
        python3 scripts/evaluateMappings.py -m {input.mappings} -g {input.graph} -r {input.reads} -o {params} > {output.res} 2> {output.log}
        """
