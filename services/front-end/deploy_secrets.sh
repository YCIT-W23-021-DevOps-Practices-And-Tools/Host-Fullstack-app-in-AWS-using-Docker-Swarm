#!/usr/bin/env bash

pushd $SERVICE_DIR > /dev/null
    docker --context=my-swarm-manager secret create ycit021_front_end_secret001 ./~~sercerts.sh
popd > /dev/null
