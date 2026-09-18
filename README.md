# ccob dotfiles

Portable shell and tooling preferences for macOS.

## Install

On this machine, link the tracked configuration:

```zsh
./install.zsh
exec zsh
```

On a new Mac with Homebrew installed, restore the preferred interactive-shell
tools and links:

```zsh
./install.zsh --packages
exec zsh
```

Existing files are moved to `~/.dotfiles-backup/TIMESTAMP/` before links are
created. Project and production dependencies are intentionally excluded.
`--packages` also installs the pinned personal Agent Skills.

Copy `shell/zshrc.local.example` to `~/.zshrc.local` for secrets, SDK paths and
host-specific settings. Copy `git/gitconfig.local.example` to
`~/.gitconfig.local` for host-specific Git settings. These files stay outside
Git.

## Layout

```text
Brewfile                 portable shell baseline
agents/                  shared Codex, Claude and OpenCode preferences
git/                     portable Git identity
shell/                   zsh startup files and theme
tooling/                 reusable formatter defaults
```

Project-local conventions remain in each project and override these defaults.

## Implementation

The repository deliberately uses a small native stack: Git for versioning, Zsh
and Oh My Zsh for the shell, Homebrew Bundle for four preferred shell helpers,
and an idempotent Zsh script for backup plus symbolic links. It does not depend
on Stow, Chezmoi, Nix or another dotfile manager.
