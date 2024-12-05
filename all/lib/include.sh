import git:install/file.sh
import git:install/path.sh
import git:install/time.sh
import git:install/sed.sh

_PROJECT_BASE_PATH=$(_readlink ~/projects)
_DATA_BASE_PATH=$(_readlink ~/.data)
SYSTEM=$(head -1 /usr/local/etc/walterjwhite/system 2>/dev/null)

_git_save() {
	local _message="$1"
	shift

	if [ -n "$_PROJECT_PATH" ]; then
		cd $_PROJECT_PATH
	fi

	git add $@ 2>/dev/null
	git commit $@ -m "$_message"

	_has_remotes=$(git remote | wc -l)
	if [ "$_has_remotes" -gt "0" ]; then
		git push
	fi
}

_git_init() {
	if [ ! -e $_PROJECT_PATH/.git ]; then
		_timeout $_CONF_GIT_CLONE_TIMEOUT _git_init git clone "$_CONF_GIT_MIRROR/$_PROJECT" $_PROJECT_PATH || {
			if [ -z "$_WARN" ]; then
				_error "Unable to initialize project"
			fi

			_warn "Initialized empty project"
			git init $_PROJECT_PATH
		}
	fi

	cd $_PROJECT_PATH
}

_git_in_project_base_path() {
	_in_path $_PROJECT_BASE_PATH
}

_git_in_user_home() {
	_in_path $HOME
}

_git_in_working_directory() {
	git status >/dev/null 2>&1
}

_git_relative_path() {
	_HOME_SED_SAFE=$(_sed_safe $(_readlink $HOME))
	_PROJECT_RELATIVE_PATH=$(pwd | sed -e "s/$_HOME_SED_SAFE\///")
}
