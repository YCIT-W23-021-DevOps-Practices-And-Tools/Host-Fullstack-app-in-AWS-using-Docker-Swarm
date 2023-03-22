#!/usr/bin/env bash

pushd $SERVICE_DIR > /dev/null
    docker --context=my-swarm-manager secret create ycit021_api_secret001 ./~~sercerts.sh
popd > /dev/null
