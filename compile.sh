#!/bin/bash
 
echo "compile"
git clone https://github.com/NCAR/wrf_hydro_nwm_public.git /job/executable/WRFHYDRO
cp  /job/data/setEnvar.sh /job/executable/WRFHYDRO/trunk/NDHMS/
cd /job/executable/WRFHYDRO/trunk/NDHMS
./configure 2
./compile_offline_NoahMP.sh setEnvar.sh
ls /job/executable/WRFHYDRO/trunk/NDHMS/Run -al
