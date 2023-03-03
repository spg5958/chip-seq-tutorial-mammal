#!/bin/bash
#SBATCH --account=open
#SBATCH --time=12:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH --mem=80GB
#SBATCH --partition=open
#SBATCH --job-name=compute_matrix
#SBATCH --output=slurm-%x-%j.out
umask 007


cd /storage/home/spg5958/group/lab/siddharth/chip-seq-tutorial-mammal/try2
computeMatrix  reference-point --regionsFileName GENCODE_VM23_mm10_genes  --scoreFileName 'R1_normalized.bw' 'R2_normalized.bw' 'R3_normalized.bw' --outFileName matrix.dat --samplesLabel 'R1 normalized' 'R2 normalized' 'R3_normalized'  --numberOfProcessors 20 --referencePoint TSS  --beforeRegionStartLength 10000 --afterRegionStartLength 10000  --sortRegions 'descend' --sortUsing 'mean' --averageTypeBins 'mean'   --binSize 10     --transcriptID transcript --exonID exon --transcript_id_designator transcript_id
plotHeatmap --matrixFile matrix.dat --outFileName histogram_GENCODE_50k.png --plotFileFormat 'png'

