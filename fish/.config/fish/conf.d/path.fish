# macOS Homebrew
if test -d /opt/homebrew/bin
    fish_add_path /opt/homebrew/bin
    fish_add_path /opt/homebrew/sbin
end

# Linux local bin (for bat → batcat symlink, etc)
fish_add_path $HOME/.local/bin

# Languages
fish_add_path $HOME/go/bin
fish_add_path $HOME/.npm-global/bin
