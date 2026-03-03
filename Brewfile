# ── Core Shell & Editor ──
brew "stow"            # Symlink manager — manages dotfile linking
brew "fish"            # Fish shell — interactive shell with autosuggestions
brew "tmux"            # Terminal multiplexer — persistent sessions, pane splitting
brew "neovim"          # Text editor — modal editing, LSP support, lua extensible
brew "git"             # Version control
brew "direnv"          # Per-directory env vars — auto-loads .envrc on cd

# ── Modern CLI Replacements ──
brew "ripgrep"         # rg — faster grep, respects .gitignore
brew "fd"              # fd — faster find, sane defaults
brew "fzf"             # Fuzzy finder — powers Ctrl+R history search via fzf.fish plugin
brew "bat"             # bat — cat with syntax highlighting and line numbers
brew "eza"             # eza — ls with icons, git status, tree view
brew "delta"           # delta — better git diff with side-by-side and syntax highlighting
brew "jq"              # JSON processor — parse, filter, transform JSON from CLI
brew "yq"              # YAML processor — same as jq but for YAML (used with pipeline configs)

# ── Dev Tools ──
brew "lazygit"         # Terminal UI for git — stage, commit, rebase, resolve conflicts visually
brew "lazydocker"      # Terminal UI for Docker — monitor containers, images, volumes, logs
brew "mosh"            # Mobile shell — SSH replacement that survives network changes
brew "fswatch"         # File watcher — triggers rebuilds on save (golden paths make watch)

# ── Version Manager ──
brew "mise"            # Polyglot version manager — replaces nvm, pyenv, SDKMAN. Manages node, python, go, java, gradle, maven per-project.

# Languages are installed via mise, not brew:
#   mise use --global node@22
#   mise use --global python@3.12
#   mise use --global go@1.22
#   mise use --global java@temurin-21
#   mise use --global gradle@8.12
#   mise use --global maven@3.9

# ── Security Scanning ──
brew "trivy"           # Vulnerability scanner — scans containers, filesystems, IaC locally

# ── Cloud & Infrastructure ──
brew "awscli"          # AWS CLI v2 — S3, ECR, ECS, IAM, CloudFormation, SST deploys
brew "tailscale"       # Mesh VPN — secure remote access to dev machine from phone
cask "docker"          # Docker Desktop — containers for local Concourse, services

# ── Fonts ──
cask "font-jetbrains-mono"  # Monospace font — used in Ghostty and nvim

# ── Python Packages (post-install) ──
# Run after brew bundle:
#   pip3 install --break-system-packages jinja2 pyyaml
# jinja2 — template engine for golden paths pipeline rendering
# pyyaml — YAML parsing for template variable loading
