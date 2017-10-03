#!/bin/bash
#
#SBATCH --job-name=jobname # Job name
#SBATCH --array=1-5
#SBATCH --nodes=1
#SBATCH --ntasks=20 # Number of cores
#SBATCH --mem=64000 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --partition=gc128 # Partition to submit to
#SBATCH --output=arrayJob_%A_%a.out # File to which STDOUT will be written
#SBATCH --error=arrayJob_%A_%a.err # File to which STDERR will be written
#SBATCH --mail-type=END # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=you@gmail.com # Email to which notifications will be sent

start=`date +%s`

hostname

echo "My SLURM_ARRAY_TASK_ID: " $SLURM_ARRAY_TASK_ID

THREADS=20

sample=`sed "${SLURM_ARRAY_TASK_ID}q;d" task_samples.txt`

rawpath=’00-RawData/'
mappath='02-STAR/'
fastq=${rawpath}${sample}_L007_R1_001.fastq.gz
mkdir ${mappath}${sample}
output=${mappath}${sample}/${sample}

module load star/2.5.1b

GENOME="Reference"
call="STAR \
--runThreadN $THREADS \
--genomeDir $GENOME \
--readFilesIn ${fastq} \
--readFilesCommand gunzip -c \
--outFileNamePrefix ${output} \
--alignIntronMin 20 \
--alignIntronMax 1000000 \
--outSAMtype BAM SortedByCoordinate \
--limitBAMsortRAM 60000000000 \
--quantMode TranscriptomeSAM GeneCounts" 
echo $call
eval $call

end=`date +%s`

runtime=$((end-start))

echo $runtime
