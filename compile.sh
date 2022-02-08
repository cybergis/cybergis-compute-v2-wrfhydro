#!/bin/bash
 
echo "compile"
env
git clone https://github.com/NCAR/wrf_hydro_nwm_public.git ${executable_folder}/WRFHYDRO
cd {executable_folder}/WRFHYDRO && git checkout ${param_git_tag_id}
cp  ${data_folder}/setEnvar.sh ${executable_folder}/WRFHYDRO/trunk/NDHMS/
cd ${executable_folder}/WRFHYDRO/trunk/NDHMS
./configure 2
./compile_offline_NoahMP.sh setEnvar.sh
ls ${executable_folder}/WRFHYDRO/trunk/NDHMS/Run -al
