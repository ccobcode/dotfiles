# ccob dotfiles

Portable shell and tooling preferences for macOS and Ubuntu.

## Install

Install from GitHub; this installs the preferred packages and links the
configuration without a manual clone:

```sh
curl -fsSL https://raw.githubusercontent.com/ccobcode/dotfiles/main/install.sh | bash
exec zsh
```

The remote installer uses `~/.dotfiles` by default and updates an existing
checkout with a fast-forward pull. On macOS, Homebrew must already be installed;
on Ubuntu, required packages are installed with APT.

From an existing checkout, link only or install packages plus links:

```zsh
./install.zsh
./install.zsh --packages
exec zsh
```

Existing files are moved to `~/.dotfiles-backup/TIMESTAMP/` before links are
created. Project and production dependencies are intentionally excluded.
`--packages` also installs the pinned personal Agent Skills. The installer
changes the login shell to Zsh only when needed. Existing tmux panes keep their
current process; run `exec zsh` once or open a new pane after installation.

Copy `shell/zshrc.local.example` to `~/.zshrc.local` for secrets, SDK paths and
host-specific settings. Copy `git/gitconfig.local.example` to
`~/.gitconfig.local` for host-specific Git settings. These files stay outside
Git.

## Layout

```text
Brewfile                 macOS shell baseline
agents/                  shared Codex, Claude and OpenCode preferences
git/                     portable Git identity
shell/                   zsh startup files and theme
tooling/                 reusable formatter defaults
```

Project-local conventions remain in each project and override these defaults.

## Implementation

The repository deliberately uses a small native stack: Git for versioning, Zsh
and Oh My Zsh for the shell, Homebrew Bundle or APT for four preferred shell
helpers, and an idempotent Zsh script for backup plus symbolic links. It does
not depend on Stow, Chezmoi, Nix or another dotfile manager.
