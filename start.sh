#!/bin/bash
podman compose down
podman compose up -d --force-recreate
