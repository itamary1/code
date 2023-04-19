#!/usr/bin/env bash

ARGPARSE_DESCRIPTION="Sample script description"      # this is optional
source /home/itamarty.cloud/softs/argparse.bash || exit 1
argparse "$@" <<EOF || exit 1
parser.add_argument('-f', '--srr_list',  type=str, help='file with list of srrs', required=True)
parser.add_argument('-g', '--gse_dir', type=str, help='Path gse directory', required=True)
parser.add_argument('-o', '--output_dir', type=str, help='Path of wanted output directory', required=True)
EOF

fastq_dir=${GSE_DIR}/Raw_fastq
mkdir -p $fastq_dir
for line in $(cat $SRR_LIST)
do echo "working on $line"
# download fastq
    # if the SRR already there
    if ls ${fastq_dir}/*$line* 1> /dev/null 2>&1; then
        echo "$line  exist"
    else 
        echo "downloading $line"
        prefetch -C yes -p $line -O ./ >> ${fastq_dir}/download_log.txt
        fasterq-dump -e 8 -O ./ ./$line >> ${fastq_dir}/download_log.txt
        mv ./*${line}*.fastq $fastq_dir
        rm -r ./$line
    fi
# run salmonTE
done
mkdir ${GSE_DIR}/outputs
docker run --name STE --rm -v ${GSE_DIR}:/data/porj_dir eipm/salmonte /bin/bash -c "SalmonTE.py quant --reference=hs --outpath=/data/porj_dir/outputs --num_threads=10 /data/porj_dir/Raw_fastq/" > run_STE.txt
docker run --rm -v $in_path_fasta:/data/fasta_dir eipm/salmonte /bin/bash -c "chmod -R 777 /data"