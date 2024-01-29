#!/bin/bash

WORK_DIR=/ebio/abt2_projects/ag-swart-paramecium/analysis

while read -r KD PREFIX PREFIX_new DOWN; do
    echo $KD
    echo $PREFIX
    echo $PREFIX_new
    echo $DOWN

    #downsample the reads and store in KD9_alternative_excision folder
    samtools view -b -s $DOWN $WORK_DIR/parties_lilia_$KD/$PREFIX/$PREFIX\_MIC/Map/$PREFIX\_MIC.ptetraurelia_mac_51_with_ies.fa.BOWTIE.sorted.ppm.bam \
> $WORK_DIR/parties_lilia_PS17_KD9/alternative_excision/$PREFIX_new\_MIC.ptetraurelia_mac_51_with_ies.fa.BOWTIE.sorted.ppm.downsampled-ppm.bam
    samtools index \
$WORK_DIR/parties_lilia_PS17_KD9/alternative_excision/$PREFIX_new\_MIC.ptetraurelia_mac_51_with_ies.fa.BOWTIE.sorted.ppm.downsampled-ppm.bam

done < $WORK_DIR/parties_lilia_PS17_KD9/alternative_excision/to_downsample.txt
