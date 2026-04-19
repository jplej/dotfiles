# Dotfiles

Minimal, keyboard-driven Linux desktop. Everything configured through text files, managed in the terminal.

- **Helix** as editor, not VS Code or vim
- **Kitty** as terminal, **tmux** for multiplexing
- **Rofi** as launcher, not application menus
- **XFCE4** as desktop but stripped down (window manager, not a desktop environment)
- **Nord** color scheme across everything (kitty, helix, btop)
- **Gammastep** for screen temperature (night mode without a DE handling it)
- **Bash**, not zsh or fish
- **Claude Code** as a primary tool

One tool per job, configured once in a text file. No plugins, no package managers layered on top, no GUI settings panels. The whole setup rebuilds on a fresh Ubuntu install in minutes.

## Chezmoi

Flat usage: `chezmoi add`, `chezmoi apply`, git commits. No templates, no scripts, no machine-specific logic.

### Naming convention

- `dot_*` → `~/.*` (e.g., `dot_bashrc` → `~/.bashrc`)
- `dot_config/*` → `~/.config/*`
- `private_*` → restricted permissions on apply

### What's tracked

**Shell**: `.bashrc`, `.profile`, `.bash_logout`
**Terminal**: `.tmux.conf`, `.config/kitty/`
**Editor**: `.config/helix/`
**Desktop**: `.config/xfce4/`, `.config/rofi/`, `.Xdefaults`, `.config/gammastep/`, `.config/gtk-4.0/`
**System**: `.config/systemd/user/`
**Apps**: `.config/btop/`, `.recoll/`, `.gitconfig`, `.xscreensaver`
**Claude**: `.claude.json` (private)

### Commands

```bash
chezmoi add ~/.some/file   # start tracking a file
chezmoi apply              # deploy repo state to home
chezmoi diff               # preview what would change
```
