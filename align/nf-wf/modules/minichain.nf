include { cat_pe } from './helpers.nf'

process fix_gfa {
    input:
    path(graph)

    output:
    path("fixed.gfa")

    script:
    """
    #!python

    with open("fixed.gfa", "w") as out:
        for line in open("$graph"):
            if line.startswith("W"):
                line = line.strip()
                _, name, hapix, seqid, seqstart, seqend, walk = line.split()
                # seqend = 1
                # seqstart = 1
                print("W", f"{name}#{hapix}_W", 1, seqid, seqstart, seqend, walk, sep="\t", file=out)
            else:
                print(line, end="", file=out)
    """
}

process minichain {
    container 'docker.io/sciccolella/minichain:1.3--db3f031'
    cpus 8

    input:
    path graph
    tuple val(sample), path(query)
    val mode

    output:
    tuple val(sample), path("output.gaf")

    script:
    """
    minichain -cx $mode -t ${task.cpus} \
        $graph $query > output.gaf
    """
    // check if empty (?)
    // if [ ! -s output.gaf ]; then echo "Empty output file"; return -1 ; fi ;

}

workflow WF_minichain {
    take:
        graph
        sample
        mode
    main:
        sample = sample | cat_pe
        graph = fix_gfa(graph)
        minichain(graph, sample, mode)
    emit:
        gaf = minichain.out
}