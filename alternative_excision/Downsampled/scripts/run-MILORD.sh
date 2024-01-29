#!/bin/bash

WORK_DIR=/ebio/abt2_projects/ag-swart-paramecium/analysis

while read -r PREFIX; do
    echo $PREFIX

    parties MILORD -genome $WORK_DIR/parties_lilia_WCPs/ptetraurelia_mac_51_with_ies.fa \
-out_dir $WORK_DIR/parties_lilia_PS17_KD9/alternative_excision/$PREFIX/ \
-bam $WORK_DIR/parties_lilia_PS17_KD9/alternative_excision/$PREFIX\_MIC.ptetraurelia_mac_51_with_ies.fa.BOWTIE.sorted.ppm.downsampled-ppm.bam \
-ies /ebio/abt2_projects/ag-swart-paramecium/data/lilia_nucleosome_profiling/nucleosome_analysis/internal_eliminated_sequence_MAC_with_IES.gff3 -threads 30 -force

done < $WORK_DIR/parties_lilia_PS17_KD9/alternative_excision/to_MILORD.txt

