#!/bin/sh

_PROJECT_BASE_PATH=~/projects

# configure mirror location
. ~/.config/git-helpers

_git() {
    cd $_PROJECT
    
    git add $1
    git commit $1 -m "$2"
    git push
}

_git_init() {
    if [ ! -e $_PROJECT ]
    then
        git init $_PROJECT

        git remote add origin "$MIRROR/$_PROJECT"
    fi
}