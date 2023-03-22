#!/usr/bin/env bash

export HOME_FOLDER=$(pwd)

export PROJECT_VERSION=$($HOME_FOLDER/printVersion.js)

if [[ -e "$HOME_FOLDER/environments.sh" ]]; then
    chmod +x "$HOME_FOLDER/environments.sh"
    source $HOME_FOLDER/environments.sh
fi

if [[ "$1" == "start" ]]; then
    docker network create ycit021-network || true
    docker compose -f $HOME_FOLDER/services/docker-compose-dev.yml up
elif [[ "$1" == "stop" ]]; then
    docker compose -f $HOME_FOLDER/services/docker-compose-dev.yml down
elif [[ "$1" == "rebuild" ]]; then
    docker compose -f $HOME_FOLDER/services/docker-compose-dev.yml rm -f
    docker compose -f $HOME_FOLDER/services/docker-compose-dev.yml build --no-cache
elif [[ "$1" == "build-and-push" ]]; then
    for service in $(ls -C "$HOME_FOLDER/services/") ; do
        if [[ ! -f $HOME_FOLDER/services/$service/build-and-push.sh ]]; then
            continue
        fi
        export SERVICE_NAME=$service

        export SERVICE_DIR=$HOME_FOLDER/services/$SERVICE_NAME

        source $HOME_FOLDER/services/$SERVICE_NAME/build-and-push.sh
    done
elif [[ "$1" == "deploy_secrets" ]]; then
    for service in $(ls -C "$HOME_FOLDER/services/") ; do
        if [[ ! -f $HOME_FOLDER/services/$service/deploy_secrets.sh ]]; then
            continue
        fi
        export SERVICE_NAME=$service

        export SERVICE_DIR=$HOME_FOLDER/services/$SERVICE_NAME

        source $HOME_FOLDER/services/$SERVICE_NAME/deploy_secrets.sh
    done
elif [[ "$1" == "deploy" ]]; then
    for service in $(ls -C "$HOME_FOLDER/services/") ; do
        if [[ ! -f $HOME_FOLDER/services/$service/deploy.sh ]]; then
            continue
        fi
        export SERVICE_NAME=$service

        export SERVICE_DIR=$HOME_FOLDER/services/$SERVICE_NAME

        source $HOME_FOLDER/services/$SERVICE_NAME/deploy.sh
    done
fi