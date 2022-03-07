# WRFHydro model support in CyberGIS-Compute V2

This repo implemented support for running WRFHydro 5.x model on HPC resources via CyberGIS-Compute V2.

Model developers who may want to contribute other models to CyberGIS-Compute can use this repo as an example.

For end-users can refer to the exampe notebook here: Open demo notebook with CyberGIS-Jupyter for Water (CJW) <a href="http://go.illinois.edu/cybergis-jupyter-water/hub/user-redirect/git-pull?repo=https%3A%2F%2Fgithub.com%2Fcybergis%2Fcybergis-compute-v2-wrfhydro&urlpath=lab%2Ftree%2Fcybergis-compute-v2-wrfhydro%2Fwrfhydro_compute_v2.ipynb&branch=main" target="_blank">HERE</a>

## manifest.json

Supported HPCs are listed by key "supported_hpc" and default HPC by key "default_hpc";

The key "slurm_input_rules" lists ranges and limits of different slurm flags will be shown to end-users with SDK GUI; For a full list of avaiable keys see https://github.com/cybergis/cybergis-compute-core/blob/v2/src/types.ts#L70

The key "pre_processing_stage", "execution_stage" and "post_processing_stage" specify the commands (and scripts) to run in preprocessing, model execution and postprocessing stages;

The key "container" lists the singularity container to use on HPC (placed on HPC already);

Other kyes for metadata: "name", "description", "estimated_runtime"

The "param_rules" section contains model-specific parameters: "Model_Version" is the tag/release/commit id/branch of the WRFHydro repo; "LSM_Type" is the land surface model to use;

## compile.sh

This script git clons the WRFHydro repo and checks out the specific version. It then applies Compile-Time configurations on top of the code base and compiles the codes on the fly. It also applies Run-Time configurations and Model Data to the "Simulation" folder.

## main.sh

This script simpily navigate to the "Simulation" folder and call the executable binary "WRFHydro.exe"

## postprocessing.sh

This script is just a place holder for future extension.

## "images" folder

This folder contains the dockerfile that builds the summa environment image and a singlarity DEF script that importes the docker image and converts to singularity container.

