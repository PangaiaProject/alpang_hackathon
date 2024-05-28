include { cat_pe } from './helpers.nf'
include { fix_gfa } from './minichain.nf'

process panaligner {
    container 'docker.io/sciccolella/panaligner:0.0--bdc00cf'
    cpus 8

    input:
    path graph
    tuple val(sample), path(query)
    val mode

    output:
    tuple val(sample), path("output.gaf")

    script:
    """
    PanAligner -cx $mode -t ${task.cpus} \
        $graph $query > output.gaf
    """
    // check if empty (?)
    // if [ ! -s output.gaf ]; then echo "Empty output file"; return -1 ; fi ;

}

workflow WF_panaligner {
    take:
        graph
        sample
        mode
    main:
        sample = sample | cat_pe
        graph = fix_gfa(graph)
        panaligner(graph, sample, mode)
    emit:
        gaf = panaligner.out
}