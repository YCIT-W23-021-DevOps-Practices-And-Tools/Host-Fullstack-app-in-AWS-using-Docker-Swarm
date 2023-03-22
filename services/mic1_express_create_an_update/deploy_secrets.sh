#!/usr/bin/env bash

pushd $SERVICE_DIR > /dev/null
    docker --context=my-swarm-manager secret create ycit021_mic1_express_create_an_update_secret002 ./~~sercerts.sh
popd > /dev/null
