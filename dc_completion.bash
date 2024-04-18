#!/usr/bin/env bash

if [ -f /usr/share/bash-completion/completions/docker ]; then
    . /usr/share/bash-completion/completions/docker
fi

_dc() {
    COMPREPLY=();

    local list=("--help" "--new" "-n" "--remove" "-r" "--list" "-l")

    if declare -F _init_completion >/dev/null 2>&1; then
        _init_completion -n =: || return
    else
        COMPREPLY=()
        _get_comp_words_by_ref "$@" cur prev words cword
    fi

    __docker_debug
    __docker_debug "========= starting completion logic =========="
    __docker_debug "cur is ${cur}, words[*] is ${words[*]}, #words[@] is ${#words[@]}, cword is $cword"

    rwords=("${words[@]:0:$cword+1}")
    __docker_debug "Real words[*]: ${rwords[*]},"

    words=("docker" "compose")

    if [ $cword == 1 ]; then
        if [ "${cur:0:1}" != "-" ]; then
            COMPREPLY=($(compgen -W "$(dc -l)" -- "${cur}"))
        else
            COMPREPLY=($(compgen -W "${list[*]}" -- "${cur}"))
        fi
    elif [[ " ${list[*]} " =~ [[:space:]]${prev}[[:space:]] ]]; then
         _cd
    else
        words=("${words[@]}" "-f" "$HOME/.config/dc/yml/${rwords[1]}" "${rwords[@]:2:${#rwords[@]}}")
        __docker_debug "words:" ${words[@]}
        cword=$(($cword + 2))
        __docker_debug "cword:" ${cword[@]}
        prev=${words[@]:0}
        __docker_debug "prev:" ${prev[@]}

        local out directive
        __docker_get_completion_results
        __docker_process_completion_results
    fi
}

complete -F _dc dc
