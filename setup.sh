#!/bin/bash

systemctl enable --now podman-restart.service
if [ $? -ne 0 ]; then
	echo -e "\nFailed to enable podman-restart.service"
	exit 1
fi

if [ -d "/opt/printer_data" ]; then
	echo -e "\nprinter_data exists, skipping..."
else
	echo -e "\nCreating printer_data..."
	mkdir -p /opt/printer_data/config
	mkdir -p /opt/printer_data/gcodes
	cp -r ./config/* /opt/printer_data/config/
	git clone --depth 1 https://github.com/kyleisah/Klipper-Adaptive-Meshing-Purging.git /opt/printer_data/config/Klipper-Adaptive-Meshing-Purging
	cd /opt/printer_data/config/
	ln -s Klipper-Adaptive-Meshing-Purging/Configuration KAMP
	cd -
fi

echo -e "\nBuilding Podman containers (this may take a while)..."
podman compose build
if [ $? -ne 0 ]; then
	echo -e "Failed to build Podman containers"
	exit 1
else
	echo -e "\n\nContainers built successfully!\n"
	cp .env.example .env
	exit 0
fi

