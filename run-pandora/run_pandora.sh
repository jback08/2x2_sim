#!/usr/bin/env bash

source setup_pandora.sh
source ../util/init.inc.sh

outDir=${ARCUBE_PANDORA_BASEDIR}
cd $outDir

# Convert input HDF5 flow file to ROOT for LArRecoND: need to check filenames & directories used here
inName=${ARCUBE_IN_NAME}.${globalIdx}
hFile=${ARCUBE_OUTDIR_BASE}/run-ndlar-flow/${ARCUBE_IN_NAME}/FLOW/${subDir}/${inName}.FLOW.hdf5

source $ARCUBE_PANDORA_INSTALL/pandora.venv/bin/activate
python3 $ARCUBE_PANDORA_INSTALL/LArRecoND/ndlarflow/h5_to_root_ndlarflow.py $inFile 0 $outDir
deactivate

# LArRecoND input ROOT file
inFile=${tmpOutDir}/${outName}.FLOW.hdf5_hits.root

# Run LArRecoND
# Create soft link to input file for hierarchy output (event numbers & trigger times)
ln -sf $inFile LArRecoNDInput.root
run ${ARCUBE_PANDORA_INSTALL}/LArRecoND/bin/PandoraInterface -i ${ARCUBE_PANDORA_INSTALL}/LArRecoND/settings/PandoraSettings_LArRecoND_ThreeD.xml \
    -r AllHitsNu -f ${ARCUBE_PANDORA_INPUT_FORMAT} -g ${ARCUBE_PANDORA_GEOM} -e $inFile -j both -M -N -n 10
