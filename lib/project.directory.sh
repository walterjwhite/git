#!/bin/sh

.  _LIBRARY_PATH/_APPLICATION_NAME/include.sh

_get_project_directory() {
	#_in=$(pwd | grep -c $HOME)
	_in=$(pwd | grep -c $_PROJECT_BASE_PATH)
	if [ "$_in" -eq "0" ]
	then
		echo "Outside home directory, unable to find project directory"
		exit 1
	fi

	if [ -e .git ]
	then
		_PROJECT_PATH=$(pwd)
		_PROJECT=$(basename $_PROJECT_PATH)

		return
	fi

	cd ..
	_get_project_directory
}

_get_project_directory
