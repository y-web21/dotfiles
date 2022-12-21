_GIT_PROMPT="/usr/local/bin/git-prompt.sh"
_BASH_COMPLETION_DIR="/etc/bash_completion.d"
# _BASH_COMPLETION_DIR="/usr/share/bash-completion/completions/" # for package manager (no file extension)
# _BASH_COMPLETION_DIR="${HOME}/.local/share/bash-completion/completions" # user made

if [ ! -f ${_GIT_PROMPT} ]; then
  curl -sS https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o ~/git-prompt.sh &&
  sudo mv ~/git-prompt.sh ${_GIT_PROMPT} &&
  sudo chmod 775 ${_GIT_PROMPT}
fi

if [ ! -d ${_BASH_COMPLETION_DIR} ]; then
  echo 'First, install bash completion before running this script. (bash >= 4.2 is required)'
  return
fi

if [[ ! -f ${_BASH_COMPLETION_DIR}/git-completion.bash ]]; then
  curl -sS https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/git-completion.bash &&
  sudo mv ~/git-completion.bash ${_BASH_COMPLETION_DIR}/ &&
  cat <<-EOF >>${_BASH_COMPLETION_DIR}/git-completion.bash
		__git_complete g __git_main
		__git_complete ga _git_add
		__git_complete gb _git_branch
		__git_complete gc _git_checkout
		__git_complete gcm _git_commit
		__git_complete gd _git_diff
		__git_complete gl _git_log
		__git_complete gs _git_status
		__git_complete gsh _git_stash
	EOF
fi
