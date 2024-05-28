process autoindex {
    conda 'bioconda::vg'
    container 'quay.io/vgteam/vg:v1.54.0'
    cpus 8

    input:
    path(graph)
    val workflow

    output:
    tuple path("idx.$workflow*.{gbz,gcsa}", arity: '1'), path("idx.$workflow*.{dist,lcp}", arity: '1'), path("idx.$workflow*.{min,xg}", arity: '1')

    script:
    """
    vg autoindex -p idx.$workflow -w $workflow -g $graph
    """
}

process giraffe {
    conda 'bioconda::vg'
    container 'quay.io/vgteam/vg:v1.54.0'
    cpus 8

    input:
    tuple path(gbz, arity: '1'), path(dist, arity: '1'), path(min, arity: '1')
    tuple val(sample), path(query, arity: '2')
    val mode

    output:
    tuple val(sample), path("output.gaf")

    script:
    def (q1, q2) = query
    
    """
    vg giraffe -p -t ${task.cpus} -Z $gbz -d $dist -m $min \
        -f $q1 -f $q2 -o gaf > output.gaf
    """
}

process vgmap {
    conda 'bioconda::vg'
    container 'quay.io/vgteam/vg:v1.54.0'
    cpus 8

    input:
    tuple path(gcsa, arity: '1'), path(lcp, arity: '1'), path(xg, arity: '1')
    tuple val(sample), path(query, arity: '2')
    val mode

    output:
    tuple val(sample), path("output.gaf")

    script:
    def (q1, q2) = query
    def preset = mode == "lr" ? "long" : "short"
    
    """
    vg map -t ${task.cpus} -x $xg -g $gcsa -m $preset \
        -f $q1 -f $q2 --gaf > output.gaf
    """
}

workflow WF_vg_map {
    take:
        graph
        sample
        mode
    main:
        graph = autoindex(graph, "map")
        vgmap(graph, sample, mode)
    emit:
        gaf = vgmap.out
}

workflow WF_vg_giraffe {
    take:
        graph
        sample
        mode
    main:
        graph = autoindex(graph, "giraffe")
        giraffe(graph, sample, mode)
    emit:
        gaf = giraffe.out
}