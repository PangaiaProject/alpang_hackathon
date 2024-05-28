// NOTE: 
// even if the README specify output format
// only as .gam or .json,
// it does also support .gaf

process graphaligner {
    container 'quay.io/biocontainers/graphaligner:1.0.19--h21ec9f0_0'
    conda 'bioconda::graphaligner'
    cpus 8

    input:
    path graph
    tuple val(sample), path(query)

    output:
    tuple val(sample), path("output.gaf")

    script:
    """
    GraphAligner -t ${task.cpus} -x vg \
        -g $graph -f $query \
        -a output.gaf
    """
}

workflow WF_graphaligner {
    take:
        graph
        sample
        mode

    main:
        graphaligner(graph, sample)

    emit:
        gaf = graphaligner.out
}