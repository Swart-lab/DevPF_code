#!/bin/bash

# check the coverage of each sample with the samtools stats command
# input are .bowtie.sorted.bam files after mapping
# provide input file names in to_stats.txt (one name each line)

WORK_DIR= #path/to/folder

while read -r PREFIX; do
    echo $WORK_DIR
    echo $PREFIX #file name

    #generate a stats file
    samtools stats $WORK_DIR/$PREFIX\_MIC.ptetraurelia_mac_51_with_ies.fa.BOWTIE.sorted.bam \
> $WORK_DIR/$PREFIX\_MIC.ptetraurelia_mac_51_with_ies.fa.BOWTIE.sorted.bam.stats

    #extract the properly paired and mapped read number
    echo $KD\_$PREFIX >> $WORK_DIR/lib_size.txt
    sed -n -e '15,15p' $WORK_DIR/$PREFIX\_MIC.ptetraurelia_mac_51_with_ies.fa.BOWTIE.sorted.bam.stats \
>> $WORK_DIR/lib_size.txt


done < $WORK_DIR/to_stats.txt
