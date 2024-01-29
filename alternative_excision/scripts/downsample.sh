#!/bin/bash

WORK_DIR= #path/to/folder

# provide file name (PREFIX), new file name (PREFIX_new) and downsampling factor (DOWN) in to_downsample.txt

while read -r PREFIX PREFIX_new DOWN; do
    echo $PREFIX
    echo $PREFIX_new
    echo $DOWN

    #extract properly paired and mapped reads
    samtools view -f2 -b $WORK_DIR/$PREFIX\_MIC.ptetraurelia_mac_51_with_ies.fa.BOWTIE.sorted.bam \
> $WORK_DIR/$PREFIX\_MIC.ptetraurelia_mac_51_with_ies.fa.BOWTIE.sorted.ppm.bam

    #downsample the reads
    samtools view -b -s $DOWN $WORK_DIR/$PREFIX\_MIC.ptetraurelia_mac_51_with_ies.fa.BOWTIE.sorted.ppm.bam \
> $WORK_DIR/$PREFIX_new\_MIC.ptetraurelia_mac_51_with_ies.fa.BOWTIE.sorted.ppm.downsampled-ppm.bam
    samtools index $WORK_DIR/$PREFIX_new\_MIC.ptetraurelia_mac_51_with_ies.fa.BOWTIE.sorted.ppm.downsampled-ppm.bam

done < $WORK_DIR/to_downsample.txt
