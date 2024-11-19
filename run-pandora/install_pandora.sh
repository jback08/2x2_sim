#!/usr/bin/env bash

export ARCUBE_RUNTIME=SHIFTER
export ARCUBE_CONTAINER=fermilab/fnal-wn-sl7:latest

source ../util/reload_in_container.inc.sh

source /cvmfs/dune.opensciencegrid.org/products/dune/setup_dune.sh
setup cmake v3_22_2
setup gcc v9_3_0
setup eigen v3_3_5
setup hdf5 v1_10_5a -q e20
# Sets ROOT version consistent with edepsim production version
setup edepsim v3_2_0c -q e20:prof

# Install directory
export ARCUBE_PANDORA_BASEDIR=$PWD
export ARCUBE_PANDORA_INSTALL=$ARCUBE_PANDORA_BASEDIR/install
mkdir -p $ARCUBE_PANDORA_INSTALL

# Pandora package versions
export ARCUBE_PANDORA_PFA_VERSION=v04-09-00
export ARCUBE_PANDORA_SDK_VERSION=v03-04-01
export ARCUBE_PANDORA_MONITORING_VERSION=v03-06-00
export ARCUBE_PANDORA_LAR_CONTENT_VERSION=v04_11_00
export ARCUBE_PANDORA_LAR_MLDATA_VERSION=v04-09-00
export ARCUBE_PANDORA_LAR_RECO_ND_VERSION=master

# PandoraPFA (cmake setup)
cd $ARCUBE_PANDORA_INSTALL
git clone https://github.com/PandoraPFA/PandoraPFA.git
cd PandoraPFA
git checkout $ARCUBE_PANDORA_PFA_VERSION

# PandoraSDK (Abstract interface and software development kit)
cd $ARCUBE_PANDORA_INSTALL
git clone https://github.com/PandoraPFA/PandoraSDK.git
cd PandoraSDK
git checkout $ARCUBE_PANDORA_SDK_VERSION
mkdir build
cd build
cmake -DCMAKE_MODULE_PATH=$ARCUBE_PANDORA_INSTALL/PandoraPFA/cmakemodules ..
make -j4 install

# PandoraMonitoring (ROOT event displays and output)
cd $ARCUBE_PANDORA_INSTALL
git clone https://github.com/PandoraPFA/PandoraMonitoring.git
cd PandoraMonitoring
git checkout $ARCUBE_PANDORA_MONITORING_VERSION
mkdir build
cd build
cmake -DCMAKE_MODULE_PATH="$ARCUBE_PANDORA_INSTALL/PandoraPFA/cmakemodules;$ROOTSYS/etc/cmake" \
-DPandoraSDK_DIR=$ARCUBE_PANDORA_INSTALL/PandoraSDK ..
make -j4 install

# LArContent (Algorithms) without LibTorch (no Deep Learning Vertexing)
cd $ARCUBE_PANDORA_INSTALL
git clone https://github.com/PandoraPFA/LArContent.git
cd LArContent
git checkout $ARCUBE_PANDORA_LAR_CONTENT_VERSION
mkdir build
cd build
cmake -DCMAKE_MODULE_PATH="$ARCUBE_PANDORA_INSTALL/PandoraPFA/cmakemodules;$ROOTSYS/etc/cmake" \
-DPANDORA_MONITORING=ON -DPandoraSDK_DIR=$ARCUBE_PANDORA_INSTALL/PandoraSDK \
-DPandoraMonitoring_DIR=$ARCUBE_PANDORA_INSTALL/PandoraMonitoring \
-DEigen3_DIR=$EIGEN_DIR/Eigen3/share/eigen3/cmake/ ..
make -j4 install

# LArRecoND (DUNE ND reco)
cd $ARCUBE_PANDORA_INSTALL
git clone https://github.com/PandoraPFA/LArRecoND.git
cd LArRecoND
git checkout $ARCUBE_PANDORA_LAR_RECO_ND_VERSION
mkdir build
cd build
cmake -DCMAKE_MODULE_PATH="$ARCUBE_PANDORA_INSTALL/PandoraPFA/cmakemodules;$ROOTSYS/etc/cmake" \
-DPANDORA_MONITORING=ON -DPandoraSDK_DIR=$ARCUBE_PANDORA_INSTALL/PandoraSDK/ \
-DPandoraMonitoring_DIR=$ARCUBE_PANDORA_INSTALL/PandoraMonitoring/ \
-DLArContent_DIR=$ARCUBE_PANDORA_INSTALL/LArContent ..
make -j4 install

# LArMachineLearningData (for BDT files etc)
cd $ARCUBE_PANDORA_INSTALL
git clone https://github.com/PandoraPFA/LArMachineLearningData.git
cd LArMachineLearningData
git checkout $ARCUBE_PANDORA_LAR_MLDATA_VERSION
# Download training files: only do this once to avoid google drive's access restrictions (up to 24 hrs wait)
#. download.sh sbnd
#. download.sh dune
#. download.sh dunend
