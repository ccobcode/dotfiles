# dotfiles

Personal configuration and tooling preferences.

This repo is for preferences that should follow the user across projects:

- editor defaults
- formatter defaults
- local tool wrappers
- reusable shell preferences

Project conventions should stay in each project. For example, if a repository has
its own `.prettierrc` or `.php-cs-fixer.php`, prefer that repository config for
that project.

## Layout

```text
tooling/
  prettier/
    prettierrc.mjs
  php-cs-fixer/
    .php-cs-fixer.php
  shell/
```
