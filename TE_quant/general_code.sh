docker pull eipm/salmonte

SRR_list=$1
GSE_dir=$2

mkdir -p $GSE_dir/Raw_fastq
for line in $(cat $SRR_list)
do
    prefetch -C yes -p $line -O $GSE_dir/Raw_fastq 
    fastq-dump -e 8  --split-3 --skip-technical -O $GSE_dir/Raw_fastq $GSE_dir/Raw_fastq/$line.sra 
done


docker run eipm/salmonte


docker run --rm -u $(id -u ${USER}):$(id -g ${USER}) -v $path_to_references:/data -v $in_path_fasta:/inputs/hg38.fa -v $in_path_gtf:/inputs/gencode.v28.annotation.gtf -t ronicohenfutheim/gtex_star:sambuseq /bin/bash -c "STAR --runMode genomeGenerate --genomeDir /data/star_index_oh75 --genomeFastaFiles /inputs/hg38.fa --sjdbGTFfile /inputs/gencode.v28.annotation.gtf --sjdbOverhang 75 --runThreadN 40"