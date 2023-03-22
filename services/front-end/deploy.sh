#!/usr/bin/env bash

pushd $SERVICE_DIR > /dev/null
    export APP_DOMAIN="app.codevteacher.com"
    docker --context=my-swarm-manager stack deploy -c deploy-swarm.yml $SERVICE_NAME
popd > /dev/null
