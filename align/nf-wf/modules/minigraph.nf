include { cat_pe } from './helpers.nf'

process minigraph {
    conda 'bioconda::minigraph'
    container 'quay.io/biocontainers/minigraph:0.20--h7132678_0'
    cpus 8

    input:
    path graph
    tuple val(sample), path(query)
    val mode

    output:
    tuple val(sample), path("output.gaf")

    script:
    """
    minigraph -cx $mode -t ${task.cpus} \
        $graph $query > output.gaf
    """
}

workflow WF_minigraph {
    take:
        graph
        sample
        mode

    main:
        sample = sample | cat_pe
        minigraph(graph, sample, mode)
    emit:
        gaf = minigraph.out
}