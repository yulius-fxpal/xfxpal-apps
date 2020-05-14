#!/bin/bash

docker run -it --rm \
    -v "/apps/synapse/data:/data" \
    -e SYNAPSE_SERVER_NAME=xfxpal.com \
    -e SYNAPSE_REPORT_STATS=yes \
    matrixdotorg/synapse:latest-py3 generate
