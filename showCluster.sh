#!/bin/bash


command -v sinfo >/dev/null 2>&1 || { echo >&2 "Command 'sinfo' not found! You're not in SLURM. Aborting."; exit 1; }

echo "CLUSTER STATUS"
echo "=============="

scontrol show partition=gc64 | grep "PartitionName" ; scontrol show partition=gc64 | grep "TotalCPUs" | sed 's/Select.*//'
scontrol show partition=gc128 | grep "PartitionName" ; scontrol show partition=gc128 | grep "TotalCPUs" | sed 's/Select.*//'
scontrol show partition=gc256 | grep "PartitionName" ; scontrol show partition=gc256 | grep "TotalCPUs" | sed 's/Select.*//'
scontrol show partition=gc512 | grep "PartitionName" ; scontrol show partition=gc512 | grep "TotalCPUs" | sed 's/Select.*//'

echo "=============="

sinfo -e -o "%P %.10g %.6c %.6D %.11m %.11T" | grep -i "g" | \
sed 's/MEMORY/MEMORY, MB/' | grep -v "^gc\*" | grep -v "down" | grep -v "drained"

echo "=============="
scontrol show config | head -n1
scontrol show config | grep "DefMemPerCPU" | sed 's/DefMemPerCPU/Default Memory Per CPU, MB/'
scontrol show config | grep "MaxArraySize" | sed 's/MaxArraySize/Max Array Size/'
scontrol show config | grep "MaxJobCount" | sed 's/MaxJobCount/Max Job Count/'
scontrol show config | grep "MaxTasksPerNode" | sed 's/MaxTasksPerNode/Max Tasks Per CPU/'
