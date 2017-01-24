#! /bin/bash

# first job - no dependencies
jid1=$(sbatch extract_fastq.slurm | cut -d " " -f 4)

# second job depends on first job
jid2=$(sbatch --dependency=afterok:$jid1 run_supernova.slurm | cut -d " " -f 4)
#jid2=$(sbatch run_supernova.slurm | cut -d " " -f 4)

# final job can depends on the previous
sbatch --dependency=afterok:$jid2 mkoutput_supernova.slurm

# show dependencies in squeue output:
squeue -u $USER -o "%.8A %.4C %.10m %.20E"
