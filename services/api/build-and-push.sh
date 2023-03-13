#!/usr/bin/env bash

pushd $SERVICE_DIR > /dev/null
    rm -rf node_modules/

    rm -rf dist/

    docker build -t "$DOCKER_LOGIN_USERNAME/ycit021_prod_$SERVICE_NAME:$PROJECT_VERSION" -f DockerfileImagePush .

    docker push "$DOCKER_LOGIN_USERNAME/ycit021_prod_$SERVICE_NAME:$PROJECT_VERSION"

popd > /dev/null
