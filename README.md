# dotfiles

Dev environment managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Setup

```bash
# macOS
brew bundle                    # install tools from Brewfile (work-safe)
brew bundle --file Brewfile.personal  # personal tools (tailscale, mosh) — skip on work machines
./stow.sh                     # link configs from Stowfile

# Linux
./scripts/setup-linux.sh      # install tools
./stow.sh                     # link configs from Stowfile
```

Then install fish plugins:

```bash
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
fisher update                  # reads fish_plugins, installs everything
tide configure                 # pick prompt style
```

Then install tmux plugins (TPM):

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# Start tmux, then press:  prefix + I  (Ctrl-a I)  to install plugins
```

## Structure

| Package  | What                                        |
|----------|---------------------------------------------|
| fish     | Shell config, aliases, functions, plugins    |
| tmux     | Multiplexer config (Ctrl-a prefix, TPM)      |
| ghostty  | Terminal theme and keybinds (Catppuccin)     |
| git      | Git config, global ignores, delta pager      |
| lazygit  | Theme and editor preset                      |
| direnv   | Per-directory env var config                 |
| nvim     | Neovim — LazyVim + Catppuccin Mocha          |

## Managing

```bash
./stow.sh                # stow all packages
./stow.sh --restow       # re-create all symlinks
./stow.sh --delete        # remove all symlinks
./stow.sh --dry-run       # preview
```
