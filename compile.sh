#!/bin/bash
 
echo "compile"
env
echo "checking out source code"
git clone https://github.com/NCAR/wrf_hydro_nwm_public.git ${executable_folder}/WRFHYDRO
cd ${executable_folder}/WRFHYDRO && git checkout ${param_git_tag_id}

echo "compiling"
chmod +x ${data_folder}/setEnvar.sh
cp  ${data_folder}/setEnvar.sh ${executable_folder}/WRFHYDRO/trunk/NDHMS/
cd ${executable_folder}/WRFHYDRO/trunk/NDHMS
chmod +x ./configure
./configure 2
chmod +x ./compile_offline_NoahMP.sh
./compile_offline_NoahMP.sh setEnvar.sh
ls ${executable_folder}/WRFHYDRO/trunk/NDHMS/Run -al

echo "setting up simulation folder"
mkdir -p ${result_folder}/Simulation
echo "copying model executable"
cp ${executable_folder}/WRFHYDRO/trunk/NDHMS/Run/*.TBL ${result_folder}/Simulation
cp ${executable_folder}/WRFHYDRO/trunk/NDHMS/Run/wrf_hydro.exe ${result_folder}/Simulation
echo "compying hydro.namelist and namelist.hrldas"
cp  ${data_folder}/namelist.hrldas  ${result_folder}/Simulation
cp  ${data_folder}/hydro.namelist  ${result_folder}/Simulation
echo "setting symbolic links to Domain and Forcing"
ln -sf ${data_folder}/FORCING ${result_folder}/Simulation
ln -sf ${data_folder}/DOMAIN ${result_folder}/Simulation
ls ${data_folder}/DOMAIN ${result_folder}/Simulation -al
