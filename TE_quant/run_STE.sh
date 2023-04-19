in_path_fasta="/home/itamarty.cloud/extDisk/samp_cache/GSE73211"
# work
background
nohup docker run --name STE --rm -v $in_path_fasta:/data/fasta_dir eipm/salmonte /bin/bash -c "SalmonTE.py quant --reference=hs --outpath=/data/fasta_dir/outputs --num_threads=10 /data/fasta_dir/Raw_fastq/; ls" > run_STE.txt &
# front
docker run --name STE --rm -v $in_path_fasta:/data/fasta_dir eipm/salmonte /bin/bash -c "SalmonTE.py quant --reference=hs --outpath=/data/fasta_dir/outputs --num_threads=10 /data/fasta_dir/Raw_fastq/; ls"
# chmod
docker run --rm -v $in_path_fasta:/data/fasta_dir eipm/salmonte /bin/bash -c "chmod -R 777 /data"

