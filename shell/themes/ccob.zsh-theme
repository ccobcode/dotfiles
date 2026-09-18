#!/usr/bin/env zsh

# Two Dark / Darcula inspired, dependency-free prompt.
setopt prompt_subst
autoload -Uz add-zsh-hook

function prompt_ccob_precmd {
	local exit_code=$?
	local width=$((${COLUMNS:-80} - 1))
	((width < 1)) && width=1

	print -P "%F{238}${(l:$width::─:)}%f"
	if ((exit_code == 0)); then
		CCOB_PROMPT_MARK='%F{75}%(!.#.%%)%f'
	else
		CCOB_PROMPT_MARK='%F{203}%(!.#.%%)%f'
	fi
}

add-zsh-hook precmd prompt_ccob_precmd

CCOB_PROMPT_CONTEXT=''
[[ -n ${SSH_CONNECTION:-} ]] && CCOB_PROMPT_CONTEXT='%F{245}%n@%m%f '

PROMPT='${CCOB_PROMPT_CONTEXT}%B%F{75}%~%f%b$(git_prompt_info) ${CCOB_PROMPT_MARK} '
RPROMPT=
RPS1=
PS2='%F{203}…%f '

ZSH_THEME_GIT_PROMPT_PREFIX=' %F{245}git:%F{114}'
ZSH_THEME_GIT_PROMPT_SUFFIX='%f'
ZSH_THEME_GIT_PROMPT_DIRTY='%F{214}*%f'
ZSH_THEME_GIT_PROMPT_CLEAN=''
