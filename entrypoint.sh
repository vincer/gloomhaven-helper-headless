#!/bin/bash

set -euo pipefail

debug="${DEBUG:-}"
		  
if [[ "$debug" ]]; then
    set -x
fi

echo "Setting up config."

if [[ ! -f ~/.ghh/config ]]; then
    echo "No existing config. Setting up basic one."
    mkdir --parents ~/.ghh && echo '{server:true,serverPort:58888}' > ~/.ghh/config
else
    echo "Existing config. Making sure server is enabled."
    sed --in-place 's/server:false/server:true/' ~/.ghh/config
    sed --in-place 's/client:true/client:false/' ~/.ghh/config
fi

if [[ -z "$@" ]]; then
    echo "Starting Gloomhaven Helper"
    JAVA_OPTS=""
    if [[ "$debug" ]]; then
	JAVA_OPTS="${JAVA_OPTS} -verbose"
    fi
    exec xvfb-run java ${JAVA_OPTS} -jar GloomhavenHelper/ghh.jar
else
    echo "Running passed command: $@"
    exec "$@"
fi
