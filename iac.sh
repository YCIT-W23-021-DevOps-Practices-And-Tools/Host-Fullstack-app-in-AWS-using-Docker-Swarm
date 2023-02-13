#!/usr/bin/env bash

HOME_FOLDER=$(pwd)

if [[ -e "$HOME_FOLDER/environments.sh" ]]; then
    chmod +x "$HOME_FOLDER/environments.sh"
    source $HOME_FOLDER/environments.sh
fi

export TF_VAR_DOCKER_LOGIN_USERNAME=$DOCKER_LOGIN_USERNAME
export TF_VAR_DOCKER_LOGIN_ACCESS_TOKEN=$DOCKER_LOGIN_ACCESS_TOKEN

if [[ "$1" == "apply-all" ]]; then
    for resource in $(ls -c $HOME_FOLDER/infrastructure); do
        pushd $HOME_FOLDER/infrastructure/$resource
            echo "Provisioning $resource"
            terraform  init
            terraform  apply -lock=false -var-file="vars.tfvars"
        popd > /dev/null
    done
elif [[ "$1" == "destroy-all" ]]; then
    for resource in $(ls -c $HOME_FOLDER/infrastructure); do
        pushd $HOME_FOLDER/infrastructure/$resource
            echo "Provisioning $resource"
            terraform  init
            terraform  destroy -lock=false -var-file="vars.tfvars"
        popd > /dev/null
    done
elif [[ -n "$1" ]]; then
    if [[ -d $HOME_FOLDER/infrastructure/$1 ]]; then
        pushd $HOME_FOLDER/infrastructure/$1
            echo "Provisioning $1"
            terraform  init
            if [[ "$2" == "apply" ]]; then
                echo "Running 'terraform apply' ..."
                terraform apply  -lock=false -var-file="vars.tfvars"
            elif [[ "$2" == "destroy" ]]; then
                echo "Running 'terraform plan' ..."
                terraform destroy  -lock=false -var-file="vars.tfvars"
            else
                echo "Running 'terraform plan' ..."
                terraform plan -lock=false -var-file="vars.tfvars"
            fi
        popd > /dev/null
    else
        echo "Error: resource folder $HOME_FOLDER/infrastructure/$1 is not exis"
        exit 1;
    fi
else
    echo "Error: Missing resource name Possible options: apply-all destroy-all $(ls -C "$HOME_FOLDER/infrastructure/")"
    exit 1;
fi