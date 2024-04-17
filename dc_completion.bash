#!/usr/bin/env bash

_dc() {
    COMPREPLY=();

    local word="${COMP_WORDS[COMP_CWORD]}"

    if [ "$COMP_CWORD" -eq 1 ]; then
        COMPREPLY=($(compgen -W "$(dc -l)" -- "$word"))
    fi
}

