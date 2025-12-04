# Dotfiles

Personal dotfiles for Windows development environments (Git Bash/MSYS2) with Claude Code integration.

## Overview

This repository manages:
- Shell configuration (Bash)
- Git settings
- SSH known hosts
- Claude Code customizations (agents, commands, settings)
- Cursor IDE settings and keybindings

## Quick Start

```bash
# Clone the repository
git clone https://github.com/lhanks/dotfiles.git /c/dev/dotfiles
cd /c/dev/dotfiles

# Run the installer
./bin/init-dotfiles
```

The installer will:
1. Enable Windows Developer Mode if needed (required for symlinks)
2. Back up existing configuration files
3. Create symbolic links from your home directory to this repo

## Repository Structure

```
dotfiles/
├── .aliases              # Bash aliases for productivity
├── .bashrc               # Bash runtime configuration
├── .bash_profile         # Bash profile initialization
├── .gitconfig            # Git user configuration
├── .ssh/
│   └── known_hosts       # Pre-configured SSH host keys
├── .claude/
│   ├── CLAUDE.md         # Claude Code preferences
│   ├── settings.json     # Claude permissions
│   └── agents/           # Custom Claude AI agents
│       ├── code-reviewer.md
│       ├── git.md
│       └── jira-helper.md
├── cursor/
│   ├── settings.json     # Cursor IDE settings
│   └── keybindings.json  # Cursor keyboard shortcuts
└── bin/
    └── init-dotfiles     # Installation script
```

## What's Included

### Shell Configuration

**`.bashrc`**
- Enables native Windows symlinks (`MSYS=winsymlinks:nativestrict`)
- Loads Angular CLI completion (when available)
- Adds Cursor IDE to PATH
- Sets Claude Code output token limit

**`.aliases`**
- Directory navigation shortcuts
- Docker commands: `dcu`, `dcd`, `dps`, `dsh`
- SSH connection shortcuts
- Utility aliases: `ll`, `menu`

### Git Configuration

**`.gitconfig`**
- User identity settings
- Merge driver configuration

### SSH Configuration

**`.ssh/known_hosts`**
- Pre-loaded host keys for Bitbucket and internal servers
- Prevents host verification prompts on first connection

### Claude Code Agents

**`code-reviewer`** - Analyzes code for bugs, security issues, and best practices

**`git`** - Git expert for all operations (commit, branch, merge, rebase, etc.). Usage: `/git commit`. Always requests permission before modifying staged files or committing.

**`jira-helper`** - Search, view, update, and create Jira issues

### Cursor IDE Configuration

**`cursor/settings.json`**
- Terminal defaults to Git Bash
- GitLens configuration
- Editor navigation preferences (go to definition/implementation)
- TypeScript formatting settings

**`cursor/keybindings.json`**
- `Ctrl+N` - Quick open (file switcher)
- `Ctrl+D` - Duplicate selection
- `Ctrl+B` - Go to definition/implementation
- `Ctrl+Shift+S` - Save all files
- `Ctrl+I` - Open Claude Code agent composer
- `F5/F8` - Debug continue

## Requirements

- Windows 10/11 with Git Bash or MSYS2
- Windows Developer Mode (installer enables this automatically)
- Git

## Customization

### Adding Aliases

Edit `.aliases` and add your shortcuts:

```bash
alias myalias='command here'
```

### Adding Claude Agents

Create a new markdown file in `.claude/agents/`:

```markdown
---
model: sonnet
---

Agent instructions here...
```

## Updating

After making changes to files in this repo, they take effect immediately since the home directory files are symlinks.

To pull updates:

```bash
cd ~/dotfiles
git pull
```

## License

MIT
