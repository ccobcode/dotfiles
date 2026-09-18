#!/usr/bin/env zsh

if (($+commands[brew])); then
	fzf_shell="${commands[brew]:h:h}/opt/fzf/shell"
	[[ -f $fzf_shell/completion.zsh ]] && source "$fzf_shell/completion.zsh"
	[[ -f $fzf_shell/key-bindings.zsh ]] && source "$fzf_shell/key-bindings.zsh"
	unset fzf_shell
fi
