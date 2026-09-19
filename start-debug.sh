#!/bin/bash
podman compose down
podman compose up --build --force-recreate
