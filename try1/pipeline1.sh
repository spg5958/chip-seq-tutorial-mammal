#!/bin/bash

genome=~/group/genomes/sacCer3/sacCer3

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

plotFingerprint --numberOfProcessors 20 --bamfiles Reb1_R1_filtered.bam Reb1_R2_filtered.bam Input_R1_filtered.bam Input_R2_filtered.bam --labels "Reb1_R1" "Reb1_R2" "Input_R1" "Input_R2" --plotFile SES_fingerprint.png --plotFileFormat 'png'
