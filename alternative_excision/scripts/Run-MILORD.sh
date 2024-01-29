#!/bin/bash

WORK_DIR= #path/to/folder

# provide names in to_MILROD.txt (one name each line)

while read -r PREFIX; do
    echo $PREFIX

    parties MILORD -genome $WORK_DIR/ptetraurelia_mac_51_with_ies.fa \
-out_dir $WORK_DIR/$PREFIX/ \
-bam $WORK_DIR/$PREFIX\_MIC.ptetraurelia_mac_51_with_ies.fa.BOWTIE.sorted.ppm.downsampled-ppm.bam \
-ies internal_eliminated_sequence_MAC_with_IES.gff3 -threads 30 -force 

done < $WORK_DIR/to_MILORD.txt
