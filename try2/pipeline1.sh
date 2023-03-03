#!/bin/bash

genome=~/group/genomes/mm10/mm10

for arg in "$@"
do
	filename=$(basename "$arg")
	filename="${filename%.*}"
	echo "Input Filename = $filename"

	outfile=${filename}.sai
	if [ ! -f $outfile ]
	then
	  bwa aln -t 40 $genome $arg > $outfile
	fi

	outfile=${filename}.sam
	if [ ! -f $outfile ]
	then
	  bwa samse $genome ${filename}.sai $arg > $outfile
	fi

	outfile=${filename}.bam
	if [ ! -f $outfile ]
	then
	  samtools sort -@40 -T temp -O bam -o $outfile ${filename}.sam 
	fi

	outfile=${filename}.bam.bai
	if [ ! -f $outfile ]
	then
	  samtools index ${filename}.bam
	fi

	outfile=${filename}_filtered.bam
	if [ ! -f $outfile ]
	then
	  samtools view -o $outfile -h -b -q 20 ${filename}.bam
	fi

	outfile=${filename}_filtered.bam.bai
	if [ ! -f $outfile ]
	then
	  samtools index ${filename}_filtered.bam
	fi
done

plotFingerprint --numberOfProcessors 40 --bamfiles Ascl1_R1_filtered.bam Ascl1_R2_filtered.bam Ascl1_R3_filtered.bam Input_filtered.bam --labels "Ascl1_R1" "Ascl1_R2" "Ascl1_R3" "Input" --plotFile SES_fingerprint.png --plotFileFormat 'png'
