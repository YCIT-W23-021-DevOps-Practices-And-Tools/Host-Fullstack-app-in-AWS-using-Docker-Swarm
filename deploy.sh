#!/usr/bin/env bash

export HOME_FOLDER=$(pwd)

export PROJECT_VERSION=$($HOME_FOLDER/printVersion.js)

if [[ "$1" == "infra" ]]; then

    echo "Making sure the iac terraform is done..."

    $HOME_FOLDER/iac.sh apply-all force
    echo "Source rds credentials"
    source $HOME_FOLDER/infrastructure/rds/~~rds_descriptor.sh

    echo "run services/mysql/prod-init.sql in prod db"
    mysql -u $rds_username -p$rds_password --host=$rds_host < services/mysql/prod-init.sql
    exit 0

fi



if [[ "$1" == "deploy_secrets" ]]; then
    ssh-keygen -R "swarm-manager.public.codevteacher.com" || true
    ssh root@swarm-manager.public.codevteacher.com "ls -la"
    $HOME_FOLDER/dev.sh deploy_secrets
    exit 0
fi
$HOME_FOLDER/dev.sh build-and-push
$HOME_FOLDER/dev.sh deploy