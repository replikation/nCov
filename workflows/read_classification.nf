include { kraken2 } from './process/kraken2.nf' 
include { krona } from './process/krona.nf' 
include { download_database_kraken2 } from './process/download_database_kraken2.nf'

workflow read_classification_wf {
    take:   
        fastq
    main: 

        // local storage via storeDir
        preload = file("${params.databases}/kraken2/GRCh38.p13_GBcovid19-2020-05-22.tar.gz")
        if (preload.exists()) { kraken_db = preload }
        else  { download_database_kraken2(); kraken_db = download_database_kraken2.out } 

        // trimming primer away is missing here (samclip macht das mit softclipped bases, aber hard coded nicht nein. seqtk?)
        kraken2(fastq, kraken_db)

        // visuals
        krona(kraken2.out)

    emit:   
        kraken2.out
}