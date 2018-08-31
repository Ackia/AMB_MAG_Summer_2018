#!/usr/bin/env nextflow
/*
 * pipeline input parameters
 */
params.reads = ""
params.outdir = ""
params.cpus = "12"
params.mem = "2"

// requires --reads for Assembly
if (params.reads == '') {
    exit 1, '--reads is a required paramater for Meta-Assembly pipeline'
}

// requires --outdir for Assembly
if (params.outdir == '') {
    exit 1, '--outdir is a required paramater for Meta-Assembly pipeline'
}

println """\
         Hybrid Assembly- N F   P I P E L I N E
         ===================================
         reads        : ${params.reads}
         outdir       : params.outdir
         """
         .stripIndent()

         reads_atropos_pe = Channel
                      .fromFilePairs(params.reads + '*{1,2}.fastq.gz', size: 2, flat: true)

process trimming_pe {
                          publishDir params.outdir/trimmed, mode: 'copy'

                          input:
                              set val(id), file(read1), file(read2) from reads_atropos_pe

                          output:
                              set val(id), file("${id}_R1_trimmed.fastq"), file("${id}_R2_trimmed.fastq") into {trimmed_reads_pe; pe_reads_fastqc; pe_reads_diamond; pe_reads_diamond; pe_reads_assembly}
                              file("${name}.report.txt") into atropos_report
                          script:
                              """
                              atropos -a TGGAATTCTCGGGTGCCAAGG -B AATGATACGGCGACCACCGAGATCTACACTCTTTCCCTACACGACGCTCTTCCGATCT \
                                  -T $params.cpus -m 50 --max-n 0 -q 20,20 -pe1 $read1 -pe2 $read2 \
                                  -o ${id}_R1_trimmed.fastq -p ${id}_R2_trimmed.fastq
                              """

}


process fastqc     {
                          publishDir params.outdir/fastqc, mode: 'copy'

                          input:
                              set val(id), file(read1), file(read2) from pe_reads_fastqc

                          output:
                              set val(id), file("${id}_R1_trimmed.fastq"), file("${id}_R2_trimmed.fastq") into

                          script:
                              """
                              atropos -a TGGAATTCTCGGGTGCCAAGG -B AATGATACGGCGACCACCGAGATCTACACTCTTTCCCTACACGACGCTCTTCCGATCT \
                                  -T $params.cpus -m 50 --max-n 0 -q 20,20 -pe1 $read1 -pe2 $read2 \
                                  -o ${id}_R1_trimmed.fastq -p ${id}_R2_trimmed.fastq
                              """
}

process multiqc     {
                          publishDir params.outdir/fastqc, mode: 'copy'

                          input:
                              set val(id), file(read1), file(read2) from reads_atropos_pe

                          output:
                              set val(id), file("${id}_R1_trimmed.fastq"), file("${id}_R2_trimmed.fastq") into {trimmed_reads_pe; pe_reads_fastqc; pe_reads_diamond; pe_reads_diamond; pe_reads_assembly}

                          script:
                              """
                              atropos -a TGGAATTCTCGGGTGCCAAGG -B AATGATACGGCGACCACCGAGATCTACACTCTTTCCCTACACGACGCTCTTCCGATCT \
                                  -T $params.cpus -m 50 --max-n 0 -q 20,20 -pe1 $read1 -pe2 $read2 \
                                  -o ${id}_R1_trimmed.fastq -p ${id}_R2_trimmed.fastq
                              """
}

process diamond     {

}

process kaiju       {

}

process kraken      {

}

process megahit      {

}

process metabat      {

}

process checkm      {

}
