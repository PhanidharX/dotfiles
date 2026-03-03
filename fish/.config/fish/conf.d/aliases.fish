# Modern CLI
alias ls "eza --icons"
alias ll "eza -la --icons --git"
alias lt "eza --tree --level=2 --icons"
alias cat "bat --plain"
alias grep "rg"
alias diff "delta"

# Navigation
alias .. "cd .."
alias ... "cd ../.."

# Git
alias g "git"
alias gs "git status -sb"
alias gd "git diff"
alias gc "git commit"
alias gp "git push"
alias gl "git log --oneline --graph -20"
alias lg "lazygit"

# Docker
alias lzd "lazydocker"
alias dc "docker compose"
alias dps "docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'"

# Concourse
alias fl "fly -t local"
alias fv "fly -t local validate-pipeline -c"

# Editor
alias v "nvim"
alias vi "nvim"
