import include.sh
import git:install/path.sh

_get_local_relative_path() {
	if [ $(readlink -f $PWD | grep -c $_PROJECT_BASE_PATH) -gt 0 ]; then
		_PROJECT_RELATIVE_PATH=$(_get_local_relative_path_filter "$_PROJECT_BASE_PATH")
		_PROJECT_PATH=$_PROJECT_BASE_PATH/$_PROJECT_RELATIVE_PATH
		_PROJECT_PATH_PWD=$(_get_local_relative_path_filter "$_PROJECT_PATH")
	elif [ $(readlink -f $PWD | grep -c $_DATA_BASE_PATH) -gt 0 ]; then
		_PROJECT_RELATIVE_PATH=$(_get_local_relative_path_filter "$_DATA_BASE_PATH")
		_PROJECT_PATH=$_DATA_BASE_PATH/$_PROJECT_RELATIVE_PATH
		_PROJECT_PATH_PWD=$(_get_local_relative_path_filter "$_PROJECT_PATH")
	else
		_error "Outside $_PROJECT_BASE_PATH | $_DATA_BASE_PATH directory, unable to find project directory @ $(_readlink $PWD)"
	fi

	_PROJECT_PATH_SED_SAFE=$(_sed_safe $_PROJECT_PATH)
}

_get_local_relative_path_filter() {
	local _sed_safe=$(_sed_safe $1)
	printf '%s' "$(readlink -f $PWD)" | sed -e "s/^.*$_sed_safe//" -e "s/^\///"
}

_get_project_directory() {
	if [ -n "$_PROJECT" ]; then
		return
	fi

	local opwd=$PWD

	while [ 1 ]; do
		if [ -e .git ]; then
			_get_local_relative_path && {
				_PROJECT=$(basename $_PROJECT_PATH)
				cd $opwd
				return
			}

			_error "Unable to get project directory: $PWD"
		fi

		_git_in_project_base_path || {
			_in_data_path || {
				local project_log_level=error
				[ "$_GIT_WARN" ] && project_log_level=warn

				_$project_log_level "Outside $_PROJECT_BASE_PATH | $_DATA_BASE_PATH directory, unable to find project directory @ $(_readlink $PWD)"
				cd $opwd
				return 1
			}
		}

		cd ..
	done
}
