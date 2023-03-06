#!/usr/bin/env bash

HOME_FOLDER=$(pwd)

if [[ "$1" == "start" ]]; then
    docker network create ycit021-network || true
    docker compose -f $HOME_FOLDER/services/docker-compose-dev.yml up
elif [[ "$1" == "stop" ]]; then
    docker compose -f $HOME_FOLDER/services/docker-compose-dev.yml down
fi