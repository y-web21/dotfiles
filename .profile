# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

    __BASH_COMPLETION_USER_DIR="${HOME}/.local/share/bash-completion/completions"
    # brew で bash-completion をインストールしていない場合
    [ ! -d ${__BASH_COMPLETION_USER_DIR} ] && mkdir -p ${__BASH_COMPLETION_USER_DIR}

    if [ -z $(brew list -1 | grep ^bash-completion$) ];then
        while read completion; do
            # ln -fs "${completion}" "${__BASH_COMPLETION_USER_DIR}"
            . ${completion}
        done < <(find ${HOMEBREW_PREFIX}/etc/bash_completion.d -type f -or -type l)
    fi
fi
# # homebrew bash-completion
# if type brew &>/dev/null; then
#     HOMEBREW_PREFIX="$(brew --prefix)"
#     if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
#         source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
#     else
#         for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
#             [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
#         done
#     fi
# fi
