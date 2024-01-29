#!/bin/bash

WORK_DIR= #path/to/input/files (in .bam format)

cd $WORK_DIR

# activate your environment
source #path/to/conda.sh
conda activate RNA

#this is for array jobs run on a cluster
#provide the file names (PREFIX) in to_quantify.txt (one name per line)

# specify the input files for the different array jobs
# line number in input file should be same number as array job number
i=$SGE_TASK_ID
PREFIX=`awk "NR==$i" to_quantify.txt `
#PREFIX=`awk "NR==$i" to_quantify.txt | cut -d' ' -f1` # new name of the sample
#KD=`awk "NR==$i" to_quantify.txt | cut -d' ' -f2` # name of the split_transcriptome used for mapping

echo $PREFIX

mkdir $WORK_DIR/$PREFIX/eXpress

express -o $WORK_DIR/$PREFIX/eXpress -O 5 --calc-covar \
/ebio/abt2_projects/ag-swart-paramecium/analysis/mRNA_lilia_ICOP/references/ptetraurelia_mac_51_annotation_v2.0.transcript.fa \
$WORK_DIR/$PREFIX/$PREFIX.n-sorted.bam

echo "finished"
