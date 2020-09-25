#!/bin/sh

. ~/.git-hooks

_action=$1
shift

_run_all() {
	if [ -d "$1" ]
	then
		  _log ".git-hooks.sh" "running hook:$_action"

		# run the hooks in order
		for _file in $(find $1 ! -type d ! -type b ! -type c ! -type p ! -type s | sort -g)
		do
			_run_file
		done
	fi
}

# for pre-commit hooks, echo them directly to the console because the user will be interacting
_run_file() {
	_log ".git-hooks.sh" "running $_file"
	_log ".git-hooks.sh" $(. $_file)
}

_run_all ".hooks/$_action"
_run_all "$_SYSTEM_HOOK_PATH/system-hooks/$_action"
