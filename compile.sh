#!/bin/bash

echo "SLURM_JOB_ID: $SLURM_JOB_ID"

echo "compile.sh"
# mkdir -p ${result_folder}/folder1
# mkdir -p ${result_folder}/folder2
# mkdir -p ${result_folder}/folder1/folder11
# echo "123" >> ${result_folder}/folder1/folder11/test11.txt
# echo "123" >> ${result_folder}/folder1/test1.txt
# echo "123" >> ${result_folder}/folder2/test2.txt
# cp -r ${data_folder} ${result_folder}/

echo "checking out source code"
git clone https://github.com/NCAR/wrf_hydro_nwm_public.git ${executable_folder}/WRFHYDRO
cd ${executable_folder}/WRFHYDRO && git checkout ${param_Model_Version}

echo "compiling"
echo "copying setEnvar.sh"
cp ${executable_folder}/WRFHYDRO/trunk/NDHMS/template/setEnvar.sh ${executable_folder}/WRFHYDRO/trunk/NDHMS/
setEnvar=${data_folder}/setEnvar.sh
if [[ -f "${setEnvar}" ]]; then
    echo "setEnvar.sh provided by user. overwriting..."
    cp  ${data_folder}/setEnvar.sh ${executable_folder}/WRFHYDRO/trunk/NDHMS/
fi
chmod +x ${executable_folder}/WRFHYDRO/trunk/NDHMS/setEnvar.sh


cd ${executable_folder}/WRFHYDRO/trunk/NDHMS
chmod +x ./configure
./configure 2
chmod +x ./compile_offline_NoahMP.sh
chmod +x ./compile_offline_Noah.sh
if [ -z "${param_LSM_Type}" ]; then
  echo "ENV parm_LSM_Type Not Set; Default to NoahMP"
  param_LSM_Type="NoahMP"
fi

if [[ "${param_LSM_Type}" != "NoahMP" && "${param_LSM_Type}" != "Noah" ]]; then
  echo "ENV parm_lsm Value Unknown; Default to NoahMP"
  param_LSM_Type="NoahMP"
fi
echo "param_LSM_Type: ${param_LSM_Type}"

echo "running: ./compile_offline_${param_LSM_Type}.sh setEnvar.sh"
./compile_offline_${param_LSM_Type}.sh setEnvar.sh
ls ${executable_folder}/WRFHYDRO/trunk/NDHMS/Run -al

echo "setting up simulation folder"
mkdir -p ${result_folder}/Simulation


echo "setting symbolic links to Domain and Forcing"
ln -sf ${data_folder}/FORCING ${result_folder}/Simulation
ln -sf ${data_folder}/DOMAIN ${result_folder}/Simulation
restart_folder=${data_folder}/RESTART
if [[ -d "${restart_folder}" ]]; then
    ln -sf ${data_folder}/RESTART  ${result_folder}/Simulation
fi

# check param_Forcing_Path
forcing_path="/compute_shared/${param_Forcing_Path}"
echo ${forcing_path}
if [[ -d "${forcing_path}" ]]; then
    echo "forcing_path [${forcing_path}] provided by user. relinking..."
    unlink ${result_folder}/Simulation/FORCING
    ln -sf ${forcing_path} ${result_folder}/Simulation/FORCING
    ls ${result_folder}/Simulation/FORCING/* -al
fi

# check param_Domain_Path
domain_path="/compute_shared/${param_Domain_Path}"
echo ${domain_path}
if [[ -d "${domain_path}" ]]; then
    echo "domain_path [${domain_path}] provided by user. relinking..."
    unlink ${result_folder}/Simulation/DOMAIN
    ln -sf ${domain_path} ${result_folder}/Simulation/DOMAIN
    ls ${result_folder}/Simulation/DOMAIN/* -al
fi

echo "copying compiled binary and static files from Run/* to Simulation/"
cp -rf ${executable_folder}/WRFHYDRO/trunk/NDHMS/Run/* ${result_folder}/Simulation/

echo "copying namelist.hrldas from repo"
namelist_hrldas=${data_folder}/namelist.hrldas
if [[ -f "${namelist_hrldas}" ]]; then
    echo "namelist.hrldas provided by user. overwriting..."
    cp  ${data_folder}/namelist.hrldas  ${result_folder}/Simulation
fi

echo "copying hydro.namelist from repo"
hydro_namelist=${data_folder}/hydro.namelist
if [[ -f "${hydro_namelist}" ]]; then
    echo "hydro.namelist provided by user. overwriting..."
    cp  ${data_folder}/hydro.namelist  ${result_folder}/Simulation
fi


ls ${data_folder}/DOMAIN ${result_folder}/Simulation -al
