#!/usr/bin/env bash

export ARCUBE_RUNTIME=SHIFTER
export ARCUBE_CONTAINER=fermilab/fnal-wn-sl7:latest
export ARCUBE_DIR=$(realpath "$PWD"/..)

source $ARCUBE_DIR/util/reload_in_container.inc.sh

source /cvmfs/dune.opensciencegrid.org/products/dune/setup_dune.sh
setup cmake v3_22_2
setup gcc v9_3_0
setup eigen v3_3_5
#setup hdf5 v1_10_5a -q e20
# Sets ROOT version consistent with edepsim production version
setup edepsim v3_2_0c -q e20:prof

# Install directory
export ARCUBE_PANDORA_BASEDIR=$PWD
export ARCUBE_PANDORA_INSTALL=$ARCUBE_PANDORA_BASEDIR/install

# Pandora package versions
export ARCUBE_PANDORA_PFA_VERSION=v04-09-00
export ARCUBE_PANDORA_SDK_VERSION=v03-04-01
export ARCUBE_PANDORA_MONITORING_VERSION=v03-06-00
export ARCUBE_PANDORA_LAR_CONTENT_VERSION=v04_11_00
export ARCUBE_PANDORA_LAR_MLDATA_VERSION=v04-09-00
export ARCUBE_PANDORA_LAR_RECO_ND_VERSION=master

# Relative path used by Pandora packages
export MY_TEST_AREA=$ARCUBE_PANDORA_INSTALL

# Geometry GDML file
GDMLName='Merged2x2MINERvA_v4_withRock'
export ARCUBE_GEOM=$ARCUBE_DIR/geometry/Merged2x2MINERvA_v4/${GDMLName}.gdml
export ARCUBE_PANDORA_GEOM=$ARCUBE_PANDORA_INSTALL/LArRecoND/${GDMLName}.root
echo "Geom: $ARCUBE_GEOM $ARCUBE_PANDORA_GEOM"
