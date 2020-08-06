path=$(cd "$(dirname "$0")";pwd)
# Run FastQC
# fastqc -o $path/../results/1_initial_qc/ --noextract $path/../input/*.fq.gz
# Run Trim Galore!
# trim_galore --quality 20 --fastqc --length 25 --output_dir $path/../results/2_trimmed_output/ $path/../input/*.fq.gz
# Run SortMeRNA
# for i in $path/../results/2_trimmed_output/*.fq.gz
# do
# 	base=`basename $i \_trimmed.fq.gz`
# 	echo sortmerna --ref /home/lanzhzh/database/RNAseq/sortmerna_db/rRNA_databases/rfam-5.8s-database-id98.fasta --ref /home/lanzhzh/database/RNAseq/sortmerna_db/rRNA_databases/rfam-5s-database-id98.fasta --ref /home/lanzhzh/database/RNAseq/sortmerna_db/rRNA_databases/silva-arc-16s-id95.fasta --ref /home/lanzhzh/database/RNAseq/sortmerna_db/rRNA_databases/silva-arc-23s-id98.fasta --ref /home/lanzhzh/database/RNAseq/sortmerna_db/rRNA_databases/silva-bac-16s-id90.fasta --ref /home/lanzhzh/database/RNAseq/sortmerna_db/rRNA_databases/silva-bac-23s-id98.fasta --ref /home/lanzhzh/database/RNAseq/sortmerna_db/rRNA_databases/silva-euk-18s-id95.fasta --ref /home/lanzhzh/database/RNAseq/sortmerna_db/rRNA_databases/silva-euk-28s-id98.fasta --reads $i --workdir $path/../results/3_rRNA/$base --aligned $path/../results/3_rRNA/$base\_aligned --other $path/../results/3_rRNA/$base\_other --fastx > $base\_SortMeRNA.sh
# 	echo $base
# done
# Run STAR
for i in $path/../results/3_rRNA/*_1_other.fq
do
	base=`basename $i \_1_other.fq`
	dirn=`dirname $i`
	echo STAR --genomeDir /home/lanzhzh/database/RNAseq/star_index/ --readFilesIn $i $dirn/$base\_2\_other.fq --runThreadN 4 --outSAMtype BAM SortedByCoordinate --quantMode GeneCounts --outFileNamePrefix $path/../results/4_aligned_sequences/$base\_ > $base\_star.sh
	echo $base
done
