include { pangolin; install_pangolin_failsave } from './process/pangolin' 

workflow determine_lineage_wf {
    take: 
        fasta  
    main:
        pangolin(fasta)

        if (workflow.profile.contains('local')) { install_pangolin_failsave() }
        
        // collect lineage also to a summary     
        channel_tmp = pangolin.out.map {it -> it[1]}
                .splitCsv(header: true, sep: ',')
                .collectFile(seed: 'sequence_name,lineage,conflict,pangoLEARN_version,status,note\n', 
                            storeDir: params.output + "/" + params.lineagedir + "/") {
                            row -> [ "metadata.csv", row.taxon + ',' + row.lineage + ',' + row.conflict + ',' + 
                            row.'pangoLEARN_version' + ',' + row.status + ',' + row.note + '\n']
                            }
    emit:
        pangolin.out
} 
