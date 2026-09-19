#!/bin/zsh
set -eu

root=${0:A:h}
install_packages=false
source "$root/agents/skills.lock"
skills_checkout="$HOME/.local/share/ccob/ponytail"

case ${1:-} in
--packages) install_packages=true ;;
"") ;;
*)
	print -u2 "usage: ./install.zsh [--packages]"
	exit 2
	;;
esac

if $install_packages; then
	case $OSTYPE in
	darwin*)
		if ! (($+commands[brew])); then
			print -u2 'Homebrew is required: https://brew.sh'
			exit 1
		fi
		HOMEBREW_BUNDLE_NO_UPGRADE=1 brew bundle --file="$root/Brewfile"
		;;
	linux*)
		[[ -r /etc/os-release ]] && source /etc/os-release
		if [[ ${ID:-} != ubuntu ]]; then
			print -u2 "unsupported Linux distribution: ${ID:-unknown}"
			exit 1
		fi
		if ((EUID == 0)); then
			sudo=()
		elif (($+commands[sudo])); then
			sudo=(sudo)
		else
			print -u2 'sudo is required to install packages'
			exit 1
		fi
		"${sudo[@]}" apt-get update
		"${sudo[@]}" env DEBIAN_FRONTEND=noninteractive apt-get install -y \
			ca-certificates fzf git zoxide zsh zsh-autosuggestions zsh-syntax-highlighting
		;;
	*)
		print -u2 "unsupported operating system: $OSTYPE"
		exit 1
		;;
	esac

	if [[ ! -d $HOME/.oh-my-zsh ]]; then
		git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
	fi

	if [[ ! -d $skills_checkout/.git ]]; then
		mkdir -p "$skills_checkout"
		git -C "$skills_checkout" init --quiet
		git -C "$skills_checkout" remote add origin "$PONYTAIL_REPOSITORY"
	fi
	if [[ $(git -C "$skills_checkout" rev-parse HEAD 2>/dev/null || true) != $PONYTAIL_REVISION ]]; then
		git -C "$skills_checkout" fetch --quiet --depth=1 origin "$PONYTAIL_REVISION"
		git -C "$skills_checkout" checkout --quiet --detach FETCH_HEAD
	fi
fi

backup_root="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

function link_path {
	local source=$1 target=$2 relative=${2#$HOME/}
	mkdir -p "${target:h}"
	if [[ -L $target && ${target:A} == ${source:A} ]]; then
		return
	fi
	if [[ -e $target || -L $target ]]; then
		mkdir -p "$backup_root/${relative:h}"
		mv "$target" "$backup_root/$relative"
	fi
	ln -s "$source" "$target"
}

link_path "$root/shell/zshrc" "$HOME/.zshrc"
link_path "$root/shell/zprofile" "$HOME/.zprofile"
link_path "$root/shell/zshenv" "$HOME/.zshenv"
link_path "$root/shell/fzf.zsh" "$HOME/.fzf.zsh"
link_path "$root/shell/themes/ccob.zsh-theme" "$HOME/.oh-my-zsh/custom/themes/ccob.zsh-theme"
link_path "$root/git/gitconfig" "$HOME/.gitconfig"
link_path "$root/agents/AGENTS.md" "$HOME/.codex/AGENTS.md"
link_path "$root/agents/AGENTS.md" "$HOME/.claude/CLAUDE.md"
link_path "$root/agents/AGENTS.md" "$HOME/.config/opencode/AGENTS.md"

if [[ -d $skills_checkout/skills ]]; then
	for skill in "$skills_checkout"/skills/*; do
		[[ -d $skill ]] || continue
		name=${skill:t}
		link_path "$skill" "$HOME/.codex/skills/$name"
		link_path "$skill" "$HOME/.claude/skills/$name"
	done
fi

login_user=$(id -un)
zsh_path=${commands[zsh]}
case $OSTYPE in
darwin*) login_shell=$(dscl . -read "/Users/$login_user" UserShell | awk '{print $2}') ;;
linux*) login_shell=$(getent passwd "$login_user" | cut -d: -f7) ;;
esac

if [[ ${login_shell:t} != zsh ]]; then
	if ((EUID == 0)); then
		chsh -s "$zsh_path" "$login_user"
	elif (($+commands[sudo])); then
		sudo chsh -s "$zsh_path" "$login_user"
	else
		chsh -s "$zsh_path"
	fi
	print "default shell changed: $login_shell -> $zsh_path"
fi

if (($+commands[tmux])) && tmux has-session 2>/dev/null; then
	tmux set-option -g default-shell "$zsh_path"
fi

print 'dotfiles linked; start a new login shell or run: exec zsh'
[[ -d $backup_root ]] && print "backup: $backup_root"
