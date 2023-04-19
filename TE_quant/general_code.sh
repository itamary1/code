docker pull eipm/salmonte

SRR_list=$1
GSE_dir=$2

mkdir -p $GSE_dir/Raw_fastq
for line in $(cat $SRR_list)
do
    prefetch -C yes -p $line -O $GSE_dir/Raw_fastq 
    fastq-dump -e 8  --split-3 --skip-technical -O $GSE_dir/Raw_fastq $GSE_dir/Raw_fastq/$line.sra 
done

in_path_fasta="/home/itamarty.cloud/extDisk/samp_cache/GSE73211"
$OUT_DIR
nohup docker run -d --rm -u $(id -u ${USER}):$(id -g ${USER}) -v $in_path_fasta:/data/fasta_dir eipm/salmonte /bin/bash -c "SalmonTE.py quant --reference=hs --outpath=/data/fasta_dir/outputs --num_threads=8 /data/fasta_dir/Raw_fastq > /data/fasta_dir/outputs/run_folder.txt" & 

docker run --rm -u $(id -u ${USER}):$(id -g ${USER}) -v $in_path_fasta:/data/fasta_dir eipm/salmonte /bin/bash -c "ls fasta_dir;ls fasta_dir/fastq"

docker run --rm eipm/salmonte /bin/bash -c "pwd"

docker run --rm -u $(id -u ${USER}):$(id -g ${USER}) -v $path_to_references:/data -v $in_path_fasta:/inputs/hg38.fa -v $in_path_gtf:/inputs/gencode.v28.annotation.gtf -t ronicohenfutheim/gtex_star:sambuseq /bin/bash -c "STAR --runMode genomeGenerate --genomeDir /data/star_index_oh75 --genomeFastaFiles /inputs/hg38.fa --sjdbGTFfile /inputs/gencode.v28.annotation.gtf --sjdbOverhang 75 --runThreadN 40"

docker run --rm -u $(id -u ${USER}):$(id -g ${USER}) -v -v $line:/inputs/hg38.fa -v $in_path_gtf:/inputs/gencode.v28.annotation.gtf -t eipm/salmonte /bin/bash -c "STAR --runMode genomeGenerate --genomeDir /data/star_index_oh75 --genomeFastaFiles /inputs/hg38.fa --sjdbGTFfile /inputs/gencode.v28.annotation.gtf --sjdbOverhang 75 --runThreadN 40"