#!/bin/bash

CONFIG_DIR="$HOME/.config/dc"
DOCKER_CONFIG_DIR="$CONFIG_DIR/yml"
if [ ! -f $DOCKER_CONFIG_DIR ]; then mkdir -p $DOCKER_CONFIG_DIR; fi

LIST=$(ls -A $DOCKER_CONFIG_DIR)

help() {
    echo "the helper command for docker compose"
    exit 0
}

new() {
    RUN="docker compose"

    DOCKER_COMPOSE_FILE=$1
    if [[ -z $DOCKER_COMPOSE_FILE ]]; then DOCKER_COMPOSE_FILE="$PWD/docker-compose.yml"; fi
    if [ ! -f $DOCKER_COMPOSE_FILE ]; then echo "docker compose file not found"; exit 1; fi

    RUN="$RUN --file $DOCKER_COMPOSE_FILE"

    ENV_FILE=$2
    if [[ -z $ENV_FILE ]]; then 
        ENV_FILE="$PWD/.env"; 
        if [ -f $ENV_FILE ]; then RUN="$RUN --env-file $ENV_FILE"; fi
    else
        if [ ! -f $ENV_FILE ]; then echo "env file not found"; exit 1; fi
    fi

    PROJECT_NAME=$3
    if [[ -z $PROJECT_NAME ]]; then
        YML=$(eval "$RUN config")
        PROJECT_NAME=$(echo $YML |sed '1q;d' | cut -d " " -f 2)
    fi
    echo $PROJECT_NAME

    docker compose --file $DOCKER_COMPOSE_FILE --env-file $ENV_FILE config > "$DOCKER_CONFIG_DIR/$PROJECT_NAME"

    echo "Successfull added"
    exit 0
}

remove() {
    PROJECT_NAME=$1
    if [[ -z $PROJECT_NAME ]]; then echo "Empty project name"; exit 1; fi
    if [ ! -f "$DOCKER_CONFIG_DIR/$PROJECT_NAME" ]; then echo "project file not found"; exit 0; fi
    rm "$DOCKER_CONFIG_DIR/$PROJECT_NAME"
    
    echo "Successfull removed"
    exit 0
}

list() {
    ls -A $DOCKER_CONFIG_DIR; exit 0;
}

CMD=$1

if [[ $CMD == "--help" || -z $CMD ]]; then help; fi

if [[ $CMD == "--new" || $CMD == "-n" ]]; then new $2 $3 $4; fi

if [[ $CMD == "--remove" || $CMD == "-r" ]]; then remove $2; fi

if [[ $CMD == "--list" || $CMD == "-l" ]]; then list; fi

if [[ -f "$DOCKER_CONFIG_DIR/$CMD" ]]; then docker compose -f "$DOCKER_CONFIG_DIR/$CMD" ${@:2}; fi
