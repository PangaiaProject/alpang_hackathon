process cat_pe {
    input:
    tuple val(sample), path(fs, arity: '2')

    output:
    tuple val(sample), path("catted.fa")

    script:
    """
    cat $fs > catted.fa
    """
}