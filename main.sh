#!/bin/bash

echo "SLURM_JOB_ID: $SLURM_JOB_ID"

echo "main.sh"
cd ${result_folder}/Simulation
./wrf_hydro.exe
echo "WRFHydro done"
