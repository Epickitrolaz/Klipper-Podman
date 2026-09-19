#!/bin/bash

# TESTING FILE DO NOT RUN

cd /opt/printer_data/config
git clone --depth 1 https://github.com/kyleisah/Klipper-Adaptive-Meshing-Purging.git
ln -s Klipper-Adaptive-Meshing-Purging/Configuration KAMP
