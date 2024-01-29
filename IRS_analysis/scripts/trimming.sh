#provide files names (PREFIX) in (for_trimming.txt; one name per line)

while read -r PREFIX; do
    echo $PREFIX

    #fastqc report on untrimmed files
    fastqc -t 40 $WORK_DIR/$PREFIX/$PREFIX\_1.fq.gz -o $WORK_DIR/Trimming/fastqc_untrimmed/
    fastqc -t 40 $WORK_DIR/$PREFIX/$PREFIX\_2.fq.gz -o $WORK_DIR/Trimming/fastqc_untrimmed/

    #tirmming with trimgalore
    trim_galore --paired --adapter AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTGGTCGCCGTATCATT \
    --adapter2 GATCGGAAGAGCACACGTCTGAACTCCAGTCACGGATGACTATCTCGTATGCCGTCTTCTGCTTG \
    --length 80 --cores 20 $WORK_DIR/$PREFIX/$PREFIX\_1.fq.gz $WORK_DIR/$PREFIX/$PREFIX\_2.fq.gz \
    --output_dir $WORK_DIR/Trimming/trim_galore_trimming/

done < $WORK_DIR/Trimming/for_trimming.txt

#fastqc reports on trimmed files:

for file in $WORK_DIR/Trimming/trim_galore_trimming/*fq.gz
do
    fastqc -t 40 $file -o $WORK_DIR/Trimming/fastqc_trimmed/
done
