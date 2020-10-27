#!/bin/sh

_PROJECT_BASE_PATH=~/projects

# configure mirror location
. _APPLICATION_CONFIG_PATH_

_git() {
    if [ -n "$_PROJECT_PATH" ]
    then
        cd $_PROJECT_PATH
    fi
    
    git add $1
    git commit $1 -m "$2"

    _has_remotes=$(git remote | wc -l)
    if [ "$_has_remotes" -gt "0" ]
    then
        git push
    fi
}

_git_init() {
    if [ ! -e $_PROJECT_PATH ]
    then
        git clone "$MIRROR/$_PROJECT" $_PROJECT_PATH
    fi
}

_git_in_project_base_path() {
    return $(pwd | grep -c $_PROJECT_BASE_PATH)
}

_git_in_user_home() {
    return $(pwd | grep -c "$HOME")
}