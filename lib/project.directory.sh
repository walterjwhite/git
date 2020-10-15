#!/bin/sh

.  _LIBRARY_PATH_/_APPLICATION_NAME_/include.sh
.  _LIBRARY_PATH_/install/logging.sh

_get_project_relative_path() {
	echo $1 | sed -e "s/^.*@//" | sed -e "s/\:\//\//g"
}

_get_local_relative_path() {
	local _length=${#_PROJECT_BASE_PATH}
	_length=$((_length + 2))

	echo $1 | cut -c $_length-
}

_get_project_directory() {
	if [ -e .git ]
	then
		_PROJECT_PATH=$(pwd)
		_PROJECT_RELATIVE_PATH=$(_get_local_relative_path $_PROJECT_PATH)
		_PROJECT=$(basename $_PROJECT_PATH)

		return
	fi

	_git_in_project_base_path
	if [ "$?" -eq "0" ]
	then
		exitWithError "Outside $_PROJECT_BASE_PATH directory, unable to find project directory @  $(pwd)" 1
	fi

	cd ..
	_get_project_directory
}

_get_project_directory
