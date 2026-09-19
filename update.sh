#!/bin/bash

echo -e "\nRemoving all containers and build cache..."
podman-compose down --volumes --remove-orphans
podman builder prune --force --all

echo -e "\nPulling git repo..."
git pull
if [ $? -ne 0 ]; then
    echo -e "\nUpdate repo failed; you may need to resolve errors manually"
    exit 1
fi

echo -e "\nBuilding Podman containers (this may take a while)..."
podman compose build
if [ $? -ne 0 ]; then
    echo "\nContainer build failed; you may need to resolve errors manually"
    exit 1
fi

echo -e "\n\nKlipper-Podman updated successfully!\n"
