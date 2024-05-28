params.graph = "/home/ciccolella/alpang_hackathon/data/21:14459766-14464736/graph.wP.unchopped.gfa"
params.pesamples = "/home/ciccolella/alpang_hackathon/data/21:14459766-14464736/illumina/reads_R{1,2}.fastq"

include { WF_minigraph } from './modules/minigraph.nf'
include { WF_graphchainer } from './modules/graphchainer.nf'
include { WF_minichain } from './modules/minichain.nf'
include { WF_graphaligner } from './modules/graphaligner.nf'
include { WF_vg_giraffe; WF_vg_map } from './modules/vg.nf'
include { WF_panaligner } from './modules/panaligner.nf'



workflow {
    Channel
        .fromFilePairs(params.pesamples, checkIfExists: true)
        .set { pe_samples }
    
    mg = WF_minigraph(params.graph, pe_samples, "sr")
    mg.gaf.view()

    gc = WF_graphchainer(params.graph, pe_samples, "sr")
    gc.gaf.view()

    mc = WF_minichain(params.graph, pe_samples, "sr")
    mc.gaf.view()

    ga = WF_graphaligner(params.graph, pe_samples, "sr")
    ga.gaf.view()

    vgg = WF_vg_giraffe(params.graph, pe_samples, "sr")
    vgg.gaf.view()

    vgm = WF_vg_map(params.graph, pe_samples, "sr")
    vgm.gaf.view()

    pan = WF_panaligner(params.graph, pe_samples, "sr")
    pan.gaf.view()
}