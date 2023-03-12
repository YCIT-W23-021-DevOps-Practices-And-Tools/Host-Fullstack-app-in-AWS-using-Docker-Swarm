#!/usr/bin/env bash

HOME_FOLDER=$(pwd)

if [[ -e "$HOME_FOLDER/environments.sh" ]]; then
    chmod +x "$HOME_FOLDER/environments.sh"
    source $HOME_FOLDER/environments.sh
fi

if [[ "$1" == "start" ]]; then
    docker network create ycit021-network || true
    docker compose -f $HOME_FOLDER/services/docker-compose-dev.yml up
elif [[ "$1" == "stop" ]]; then
    docker compose -f $HOME_FOLDER/services/docker-compose-dev.yml down
fi