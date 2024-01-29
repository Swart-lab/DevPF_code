#!/bin/bash

WORK_DIR= #path/to/folder

cd $WORK_DIR

# activate your environment
source #path/to/conda.sh
conda activate #include your environment name

#this script is for an array job on a cluster

# specify the input files for the different array jobs
# lines in he file should be same number as array job number
i=$SGE_TASK_ID
#PREFIX=`awk "NR==$i" to_map.txt `
NAME=`awk "NR==$i" to_mapKD9.txt | cut -d' ' -f1` # how sample is called in sequencing output
PREFIX=`awk "NR==$i" to_mapKD9.txt | cut -d' ' -f2` # new name of the sample

echo $NAME
echo $PREFIX

# pre-clean and generate directory to store files in
rm -r $WORK_DIR/$PREFIX/
mkdir $WORK_DIR/$PREFIX/

#map the reads to the transcriptome
#It is important that you allow many multi-mappings (preferably unlimited) in order to allow eXpress to select the correct alignment instead of the mapper
# therefore -k option
hisat2 --threads 16 -k 20 -q -x ptetraurelia_mac_51_annotation_v2.0.transcript.fa \
--min-intronlen 10 --max-intronlen 500000 \
-1 ${NAME}_R1_1.fq.gz \
-2 ${NAME}_R2__2.fq.gz \
-S $WORK_DIR/$PREFIX/${PREFIX}.sam

#extract the properly mapping and paired reads
samtools view -@ 8 -f2 -bT ptetraurelia_mac_51_annotation_v2.0.transcript.fa \
$WORK_DIR/$PREFIX/${PREFIX}.sam > $WORK_DIR/$PREFIX/${PREFIX}.bam

#sort them by name for eXpress
samtools sort -n -@ 8 -o $WORK_DIR/$PREFIX/$PREFIX.n-sorted.bam $WORK_DIR/$PREFIX/${PREFIX}.bam
samtools stats -@ 8 $WORK_DIR/$PREFIX/$PREFIX.n-sorted.bam > $WORK_DIR/$PREFIX/$PREFIX.n-sorted.bam.stats

#sort them by location to extract specific regions for visualization in Geneious
samtools sort -@ 8 -o $WORK_DIR/$PREFIX/$PREFIX.sorted.bam $WORK_DIR/$PREFIX/$PREFIX.bam
samtools stats -@ 8 $WORK_DIR/$PREFIX/$PREFIX.sorted.bam > $WORK_DIR/$PREFIX/$PREFIX.sorted.bam.stats
samtools index $WORK_DIR/$PREFIX/$PREFIX.sorted.bam

#extract the properly paired and mapped read number
echo $PREFIX >> $WORK_DIR/lib_size_ppm.txt
sed -n -e '15,15p' $WORK_DIR/$PREFIX/$PREFIX.sorted.bam.stats \
>> $WORK_DIR/lib_size_ppm.txt


rm $WORK_DIR/$PREFIX/${PREFIX}.sam

echo "finished"
