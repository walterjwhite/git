#!/bin/sh

_PROJECT_BASE_PATH=~/projects

# configure mirror location
. _APPLICATION_CONFIG_PATH_

_git() {
    cd $_PROJECT_PATH
    
    git add $1
    git commit $1 -m "$2"
    git push
}

_git_init() {
    if [ ! -e $_PROJECT_PATH ]
    then
        git clone "$MIRROR/$_PROJECT" $_PROJECT_PATH
    fi
}