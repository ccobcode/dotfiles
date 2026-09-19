#!/usr/bin/env bash
set -euo pipefail

repository=${DOTFILES_REPOSITORY:-https://github.com/ccobcode/dotfiles.git}
target=${DOTFILES_DIR:-$HOME/.dotfiles}

missing=()
command -v git >/dev/null || missing+=(git)
command -v zsh >/dev/null || missing+=(zsh)

if ((${#missing[@]})); then
	if [[ $(uname -s) != Linux ]] || [[ ! -r /etc/os-release ]]; then
		echo "missing required commands: ${missing[*]}" >&2
		exit 1
	fi
	. /etc/os-release
	if [[ ${ID:-} != ubuntu ]]; then
		echo "unsupported Linux distribution: ${ID:-unknown}" >&2
		exit 1
	fi
	if ((EUID == 0)); then
		sudo=()
	elif command -v sudo >/dev/null; then
		sudo=(sudo)
	else
		echo 'sudo is required to install git and zsh' >&2
		exit 1
	fi
	"${sudo[@]}" apt-get update
	"${sudo[@]}" env DEBIAN_FRONTEND=noninteractive apt-get install -y "${missing[@]}"
fi

if [[ -d $target/.git ]]; then
	git -C "$target" pull --ff-only
elif [[ -e $target ]]; then
	echo "install target already exists and is not a Git repository: $target" >&2
	exit 1
else
	git clone --depth=1 "$repository" "$target"
fi

(($#)) || set -- --packages
exec zsh "$target/install.zsh" "$@"
