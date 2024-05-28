// NOTE: 
// even if the README specify output format
// only as .gam or .json,
// it does also support .gaf

process graphchainer {
    container 'docker.io/sciccolella/graphchainer:1.0.2--3d22739'
    cpus 8

    input:
    path graph
    tuple val(sample), path(query)

    output:
    tuple val(sample), path("output.gaf")

    script:
    """
    GraphChainer -t ${task.cpus} \
        -f $query -g $graph -a output.gaf
    """
    // --sampling-step $params.sampling_step \
    // --colinear-split-len $params.colinear_split_len \
    // --colinear-gap $params.colinear_gap \
}

workflow WF_graphchainer {
    take:
        graph
        sample
        mode

    main:
        graphchainer(graph, sample)

    emit:
        gaf = graphchainer.out
}