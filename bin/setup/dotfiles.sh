#!/bin/zsh
# Script to automatically set up and maintain dotfile preferences that cannot
# be stored directly in git.

set -o errexit
set -o nounset
set -o pipefail

DEBUG=${DEBUG:-0}

if [ $DEBUG -ne 0 ]; then
	set -o verbose
fi

debug_log () {
	if [ $DEBUG -ne 0 ]; then
		echo -e "DEBUG:" "$@"
	fi
}

# We have several preferences specific to this repo we'd like to have on all
# computers. Git doesn't do this automatically since it's a potential security
# vulnerability, but we have sole control over the repo so we can safely set
# a file in the repo to be included.
setup_git_config_include () {
	INCLUDE_PATH='../.gitconfig.repo'
	INCLUDE_PATH_REGEXP=`echo "$INCLUDE_PATH" | sed 's/\./\\\\./g'`
	debug_log "git include path, regexp: '$INCLUDE_PATH' '$INCLUDE_PATH_REGEXP'"
	if git config --get-all include.path "$INCLUDE_PATH_REGEXP" > /dev/null; then
		debug_log "git includes already established."
		return 0
	fi
	git config --local include.path "$INCLUDE_PATH"
	debug_log "git includes added"
}

# The git update cron (see below) only works if it can access the remote
# noninteractively, which means we need an HTTPS origin. Push however only
# works over git-ssh. This sets up the repo to use separate URLs for fetch and
# push to satisfy these requirements.
setup_git_split_origin () {
	HTTPS_URL='https://github.com/reacocard/dotfiles.git'
	GIT_URL='git@github.com:reacocard/dotfiles.git'
	if git remote get-url --all origin | grep "$HTTPS_URL" > /dev/null; then
		debug_log "git fetch url already set."
	else
		git remote set-url origin "$HTTPS_URL"
		debug_log "git fetch url updated."
	fi
	if git remote get-url --push --all origin | grep "$GIT_URL" > /dev/null; then
		debug_log "git push url already set."
	else
		git remote set-url origin --push "$GIT_URL"
		debug_log "git push url updated."
	fi
}

# Gnome will 'helpfully' edit our user-dirs config for us if the directories
# don't exist.
fix_xdg_dirs () {
	mkdir -p $HOME/.local/xdg-{templates,public}
	mkdir -p $HOME/media/{music,pictures,video}
	git checkout .config/user-dirs.dirs
}

main () {
	cd "$HOME"
	setup_git_config_include
	setup_git_split_origin
	fix_xdg_dirs
}

main "$@"
