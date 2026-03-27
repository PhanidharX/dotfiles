# macOS Homebrew
if test -d /opt/homebrew/bin
    fish_add_path /opt/homebrew/bin
    fish_add_path /opt/homebrew/sbin
end

# Linux local bin (for bat → batcat symlink, etc)
fish_add_path $HOME/.local/bin
# User bin — versioned CLIs like fly-7.11, fly-7.9
fish_add_path $HOME/bin

# Languages
fish_add_path $HOME/go/bin
fish_add_path $HOME/.npm-global/bin
