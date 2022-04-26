#!/bin/bash

echo "SLURM_JOB_ID: $SLURM_JOB_ID"

echo "postprocessing.sh"

cd ${result_folder}/Simulation

function CountFiles () {
   #echo "Couting $1"
   count=`ls -dp $1 | wc -l`
   echo $count
}

function MoveFiles () {
   pattern=$1
   target_folder_path=$2
   count=`CountFiles "$pattern"`
   if [[ "$count" -gt 0 ]]; then
     echo "moving $1: $count"
     mkdir -p $target_folder_path
     mv $1 $target_folder_path
   fi

}

OUTPUT_ROOT=${result_folder}/Outputs

#*.CHRTOUT_DOMAIN* --> CHRTOUT
MoveFiles "*.CHRTOUT_DOMAIN*" "$OUTPUT_ROOT/CHRTOUT"

#*.LDASOUT_DOMAIN* -->	LDASOUT
MoveFiles "*.LDASOUT_DOMAIN*" "$OUTPUT_ROOT/LDASOUT"

#*.GWOUT_DOMAIN* -->  GWOUT
MoveFiles "*.GWOUT_DOMAIN*" "$OUTPUT_ROOT/GWOUT"

#*.LSMOUT_DOMAIN* -->  LSMOUT
MoveFiles "*.LSMOUT_DOMAIN*" "$OUTPUT_ROOT/LSMOUT"

#*.RTOUT_DOMAIN* -->  RTOUT
MoveFiles "*.RTOUT_DOMAIN*" "$OUTPUT_ROOT/RTOUT"

#HYDRO_RST.*_DOMAIN* -->  HYDRO_RST
MoveFiles "HYDRO_RST.*_DOMAIN*" "$OUTPUT_ROOT/HYDRO_RST"

#RESTART.*_DOMAIN* -->  RESTART
MoveFiles "RESTART.*_DOMAIN*" "$OUTPUT_ROOT/RESTART"

#diag_hydro.* -->  diag_hydro
MoveFiles "diag_hydro.*" "$OUTPUT_ROOT/diag_hydro"

#*.LAKEOUT_DOMAIN* -->  LAKEOUT
MoveFiles "*.LAKEOUT_DOMAIN*" "$OUTPUT_ROOT/LAKEOUT"

#*.CHANOBS_DOMAIN* -->  CHANOBS
MoveFiles "*.CHANOBS_DOMAIN*" "$OUTPUT_ROOT/CHANOBS"


# ls -1 20181*.LSMOUT_DOMAIN1 | sort | tr '\n' ' ' | xargs -i bash -c "ncrcat {} output.nc"



MERGE_FOLDER_NAME=Merged

if [[ "${param_Merge_Output}" = "True" ]]; then
  echo "Merge Outputs ..."

  python ${executable_folder}/merge_nc.py "$OUTPUT_ROOT/CHANOBS/*.CHANOBS_DOMAIN1" "$OUTPUT_ROOT/${MERGE_FOLDER_NAME}/CHANOBS/CHANOBS_DOMAIN1_merged.nc"
  python ${executable_folder}/merge_nc.py "$OUTPUT_ROOT/LDASOUT/*.LDASOUT_DOMAIN1" "$OUTPUT_ROOT/${MERGE_FOLDER_NAME}/LDASOUT/LDASOUT_DOMAIN1_merged.nc"
  python ${executable_folder}/merge_nc.py "$OUTPUT_ROOT/CHRTOUT/*.CHRTOUT_DOMAIN1" "$OUTPUT_ROOT/${MERGE_FOLDER_NAME}/CHRTOUT/CHRTOUT_DOMAIN1_merged.nc"
  python ${executable_folder}/merge_nc.py "$OUTPUT_ROOT/GWOUT/*.GWOUT_DOMAIN1" "$OUTPUT_ROOT/${MERGE_FOLDER_NAME}/GWOUT/GWOUT_DOMAIN1_merged.nc"
  python ${executable_folder}/merge_nc.py "$OUTPUT_ROOT/LAKEOUT/*.LAKEOUT_DOMAIN1" "$OUTPUT_ROOT/${MERGE_FOLDER_NAME}/LAKEOUT/LAKEOUT_DOMAIN1_merged.nc"
  python ${executable_folder}/merge_nc.py "$OUTPUT_ROOT/RTOUT/*.RTOUT_DOMAIN1" "$OUTPUT_ROOT/${MERGE_FOLDER_NAME}/RTOUT/RTOUT_DOMAIN1_merged.nc"
  python ${executable_folder}/merge_nc.py "$OUTPUT_ROOT/LSMOUT/*.LSMOUT_DOMAIN1" "$OUTPUT_ROOT/${MERGE_FOLDER_NAME}/LSMOUT/LSMOUT_DOMAIN1_merged.nc"
fi


echo "postprocessing done"
