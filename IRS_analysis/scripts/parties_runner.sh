TMP_DIR= #path/to/folder
ANALYSIS_DIR=$5
GENOME_DIR= #path/to/reference/genomes
MAC_NAME=$3_MAC
MIC_NAME=$3_MIC
MAC_DIR=$TMP_DIR/$MAC_NAME
MIC_DIR=$TMP_DIR/$MIC_NAME
RESULTS_DIR=$TMP_DIR/$3_results
NUM_THREADS=$4

#precleanup to prevent errors by parties when directories are present
rm -rf $MAC_DIR
rm -rf $MIC_DIR
rm -rf $RESULTS_DIR

fq1_gz=`get_filename_from_path.py $1` 
fq2_gz=`get_filename_from_path.py $2` 
fq1=$TMP_DIR/fastq/`echo $fq1_gz | cut -f 1,2 -d "."`
fq2=$TMP_DIR/fastq/`echo $fq2_gz | cut -f 1,2 -d "."`

mkdir -p $TMP_DIR
mkdir -p $TMP_DIR/fastq

cp $1 $TMP_DIR/fastq
cp $2 $TMP_DIR/fastq
gunzip -f $TMP_DIR/fastq/$fq1_gz
gunzip -f $TMP_DIR/fastq/$fq2_gz

echo "parties Map -genome $GENOME_DIR/ptetraurelia_mac_51.fa -fastq1 $fq1 -fastq2 $fq2 -out_dir $MAC_DIR -threads $NUM_THREADS -force"
parties Map -genome $GENOME_DIR/ptetraurelia_mac_51.fa -fastq1 $fq1 -fastq2 $fq2 -out_dir $MAC_DIR -threads $NUM_THREADS -force
echo "parties Map -genome $GENOME_DIR/ptetraurelia_mac_51_with_ies.fa -fastq1 $fq1 -fastq2 $fq2 -out_dir $MIC_DIR -threads $NUM_THREADS -force"
parties Map -genome $GENOME_DIR/ptetraurelia_mac_51_with_ies.fa -fastq1 $fq1 -fastq2 $fq2 -out_dir $MIC_DIR -threads $NUM_THREADS -force

echo "parties MIRET -genome $GENOME_DIR/ptetraurelia_mac_51.fa -germline_genome $GENOME_DIR/ptetraurelia_mac_51_with_IES.fa 
-bam $MAC_DIR/Map/${MAC_NAME}.ptetraurelia_mac_51.fa.BOWTIE.sorted.bam -germline_bam $MIC_DIR/Map/${MIC_NAME}.ptetraurelia_mac_51_with_ies.fa.BOWTIE.sorted.bam \
-ies $GENOME_DIR/internal_eliminated_sequence_MAC.gff3 -germline_ies $GENOME_DIR/internal_eliminated_sequence_MAC_with_IES.gff3 -out_dir $RESULTS_DIR \
-score_method IES -threads $NUM_THREADS -force"
parties MIRET -genome $GENOME_DIR/ptetraurelia_mac_51.fa -germline_genome $GENOME_DIR/ptetraurelia_mac_51_with_IES.fa \
-bam $MAC_DIR/Map/${MAC_NAME}.ptetraurelia_mac_51.fa.BOWTIE.sorted.bam -germline_bam $MIC_DIR/Map/${MIC_NAME}.ptetraurelia_mac_51_with_ies.fa.BOWTIE.sorted.bam \
-ies $GENOME_DIR/internal_eliminated_sequence_MAC.gff3 -germline_ies $GENOME_DIR/internal_eliminated_sequence_MAC_with_IES.gff3 \
-out_dir $RESULTS_DIR -score_method IES -threads $NUM_THREADS -force>

cp -r $RESULTS_DIR $ANALYSIS_DIR
cp -r $MAC_DIR $ANALYSIS_DIR
cp -r $MIC_DIR $ANALYSIS_DIR

rm -rf $RESULTS_DIR
rm -rf $MAC_DIR
rm -rf $MIC_DIR
rm $fq1
rm $fq2
