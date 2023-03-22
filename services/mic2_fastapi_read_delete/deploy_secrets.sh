#!/usr/bin/env bash

pushd $SERVICE_DIR > /dev/null
    docker --context=my-swarm-manager secret create ycit021_mic2_fastapi_read_delete_secret002 ./~~sercerts.sh
popd > /dev/null