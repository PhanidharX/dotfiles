#!/usr/bin/env bash
set -e

# ──────────────────────────────────────────────────────────
# setup-linux.sh
# Installs all dev tools on Linux (Debian/Ubuntu, Fedora, Arch)
# Run once on a fresh machine, then use stow for dotfiles.
# ──────────────────────────────────────────────────────────

# Detect package manager
if command -v pacman &>/dev/null; then
    PM="pacman"
elif command -v dnf &>/dev/null; then
    PM="dnf"
elif command -v apt-get &>/dev/null; then
    PM="apt"
else
    echo "✗ Unsupported package manager. Needs apt, dnf, or pacman." && exit 1
fi

echo "▸ Detected package manager: $PM"
echo ""

# ── Helper: install from GitHub release ──
install_github_release() {
    local name=$1 repo=$2 pattern=$3
    if command -v "$name" &>/dev/null; then
        echo "  ✓ $name already installed"
        return
    fi
    echo "  ▸ Installing $name from GitHub..."
    local version
    version=$(curl -sL "https://api.github.com/repos/$repo/releases/latest" | jq -r .tag_name)
    local url="https://github.com/$repo/releases/download/${version}/${pattern/\{VERSION\}/${version#v}}"
    local tmpdir
    tmpdir=$(mktemp -d)
    curl -sL "$url" -o "$tmpdir/download"
    if [[ "$url" == *.deb ]]; then
        sudo dpkg -i "$tmpdir/download" 2>/dev/null || sudo apt-get install -f -y
    elif [[ "$url" == *.tar.gz ]]; then
        tar xzf "$tmpdir/download" -C "$tmpdir"
        sudo mv "$tmpdir/$name" /usr/local/bin/
    else
        chmod +x "$tmpdir/download"
        sudo mv "$tmpdir/download" "/usr/local/bin/$name"
    fi
    rm -rf "$tmpdir"
}


# ════════════════════════════════════════════════════════════
#  CORE SHELL & EDITOR
# ════════════════════════════════════════════════════════════
echo "▸ Installing core shell & editor tools..."

case $PM in
    pacman)
        sudo pacman -S --needed --noconfirm \
            stow             `# Symlink manager — manages dotfile linking` \
            fish             `# Fish shell — interactive shell with autosuggestions` \
            tmux             `# Terminal multiplexer — persistent sessions, pane splitting` \
            neovim           `# Text editor — modal editing, LSP, lua extensible` \
            git              `# Version control` \
            direnv           `# Per-directory env vars — auto-loads .envrc on cd`
        ;;
    dnf)
        sudo dnf install -y \
            stow fish tmux neovim git direnv
        ;;
    apt)
        sudo apt-get update
        sudo apt-get install -y \
            stow fish tmux neovim git direnv
        ;;
esac


# ════════════════════════════════════════════════════════════
#  MODERN CLI REPLACEMENTS
# ════════════════════════════════════════════════════════════
echo "▸ Installing modern CLI replacements..."

case $PM in
    pacman)
        sudo pacman -S --needed --noconfirm \
            ripgrep          `# rg — faster grep, respects .gitignore` \
            fd               `# fd — faster find, sane defaults` \
            fzf              `# Fuzzy finder — powers Ctrl+R via fzf.fish plugin` \
            bat              `# bat — cat with syntax highlighting` \
            eza              `# eza — ls with icons, git status, tree view` \
            git-delta        `# delta — better git diff, side-by-side + syntax highlighting` \
            jq               `# JSON processor` \
            yq               `# YAML processor — used with pipeline configs`
        ;;
    dnf)
        sudo dnf install -y \
            ripgrep fd-find fzf bat \
            jq
        # eza, delta, yq — install from GitHub (not in Fedora repos)
        ;;
    apt)
        sudo apt-get install -y \
            ripgrep fzf jq

        # fd is 'fd-find' on Debian/Ubuntu — needs symlink
        sudo apt-get install -y fd-find
        mkdir -p ~/.local/bin
        [ ! -L ~/.local/bin/fd ] && ln -sf /usr/bin/fdfind ~/.local/bin/fd || true

        # bat is 'batcat' on Debian/Ubuntu — needs symlink
        sudo apt-get install -y bat
        [ ! -L ~/.local/bin/bat ] && ln -sf /usr/bin/batcat ~/.local/bin/bat || true
        ;;
esac

# eza — ls replacement with icons and git integration
if ! command -v eza &>/dev/null; then
    case $PM in
        pacman) ;; # already installed above
        *)
            echo "  ▸ Installing eza from GitHub..."
            EZA_VERSION=$(curl -sL https://api.github.com/repos/eza-community/eza/releases/latest | jq -r .tag_name)
            curl -sL "https://github.com/eza-community/eza/releases/download/${EZA_VERSION}/eza_x86_64-unknown-linux-gnu.tar.gz" | tar xz -C /tmp
            sudo mv /tmp/eza /usr/local/bin/
            ;;
    esac
fi

# delta — git diff with syntax highlighting and side-by-side
if ! command -v delta &>/dev/null; then
    case $PM in
        pacman) ;; # already installed as git-delta above
        dnf)
            install_github_release "delta" "dandavison/delta" "git-delta-{VERSION}-x86_64-unknown-linux-gnu.tar.gz"
            ;;
        apt)
            echo "  ▸ Installing delta from GitHub..."
            DELTA_VERSION=$(curl -sL https://api.github.com/repos/dandavison/delta/releases/latest | jq -r .tag_name)
            curl -sLO "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION}_amd64.deb"
            sudo dpkg -i "git-delta_${DELTA_VERSION}_amd64.deb" 2>/dev/null || sudo apt-get install -f -y
            rm -f "git-delta_${DELTA_VERSION}_amd64.deb"
            ;;
    esac
fi

# yq — YAML processor (like jq for YAML)
if ! command -v yq &>/dev/null; then
    case $PM in
        pacman) ;; # already installed above
        *)
            echo "  ▸ Installing yq from GitHub..."
            YQ_VERSION=$(curl -sL https://api.github.com/repos/mikefarah/yq/releases/latest | jq -r .tag_name)
            curl -sL "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64" -o /tmp/yq
            chmod +x /tmp/yq
            sudo mv /tmp/yq /usr/local/bin/yq
            ;;
    esac
fi


# ════════════════════════════════════════════════════════════
#  DEV TOOLS
# ════════════════════════════════════════════════════════════
echo "▸ Installing dev tools..."

case $PM in
    pacman)
        sudo pacman -S --needed --noconfirm \
            mosh             `# Mobile shell — SSH replacement, survives network changes` \
            inotify-tools    `# File watcher — inotifywait for watch mode (Linux alternative to fswatch)`

        # lazygit and lazydocker are in AUR
        if command -v yay &>/dev/null; then
            yay -S --needed --noconfirm lazygit lazydocker
        elif command -v paru &>/dev/null; then
            paru -S --needed --noconfirm lazygit lazydocker
        else
            echo "  ⚠ Install an AUR helper (yay or paru) then: yay -S lazygit lazydocker"
        fi
        ;;
    dnf)
        sudo dnf install -y mosh inotify-tools
        ;;
    apt)
        sudo apt-get install -y mosh inotify-tools
        ;;
esac

# lazygit — terminal UI for git (stage, commit, rebase visually)
if ! command -v lazygit &>/dev/null && [ "$PM" != "pacman" ]; then
    echo "  ▸ Installing lazygit from GitHub..."
    LAZYGIT_VERSION=$(curl -sL https://api.github.com/repos/jesseduffield/lazygit/releases/latest | jq -r .tag_name | tr -d 'v')
    curl -sL "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" | tar xz -C /tmp lazygit
    sudo mv /tmp/lazygit /usr/local/bin/
fi

# lazydocker — terminal UI for Docker (monitor containers, logs, stats)
if ! command -v lazydocker &>/dev/null && [ "$PM" != "pacman" ]; then
    echo "  ▸ Installing lazydocker from GitHub..."
    LAZYDOCKER_VERSION=$(curl -sL https://api.github.com/repos/jesseduffield/lazydocker/releases/latest | jq -r .tag_name | tr -d 'v')
    curl -sL "https://github.com/jesseduffield/lazydocker/releases/download/v${LAZYDOCKER_VERSION}/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz" | tar xz -C /tmp lazydocker
    sudo mv /tmp/lazydocker /usr/local/bin/
fi


# ════════════════════════════════════════════════════════════
#  VERSION MANAGER (mise — replaces nvm, pyenv, SDKMAN)
# ════════════════════════════════════════════════════════════
echo "▸ Installing mise version manager..."

if ! command -v mise &>/dev/null; then
    curl https://mise.run | sh
    echo "  ✓ mise installed"
else
    echo "  ✓ mise already installed"
fi

# Languages are installed via mise after dotfiles are stowed and fish is configured:
#   mise use --global node@22
#   mise use --global python@3.12
#   mise use --global go@1.22
#   mise use --global java@temurin-21
#   mise use --global gradle@8.12
#   mise use --global maven@3.9


# ════════════════════════════════════════════════════════════
#  SECURITY SCANNING
# ════════════════════════════════════════════════════════════
echo "▸ Installing security scanning tools..."

# trivy — vulnerability scanner for containers, filesystems, IaC
if ! command -v trivy &>/dev/null; then
    case $PM in
        pacman)
            # trivy is in AUR
            if command -v yay &>/dev/null; then
                yay -S --needed --noconfirm trivy
            elif command -v paru &>/dev/null; then
                paru -S --needed --noconfirm trivy
            else
                echo "  ⚠ Install trivy from AUR: yay -S trivy"
            fi
            ;;
        dnf)
            # Trivy has an official RPM repo
            sudo rpm --import https://aquasecurity.github.io/trivy-repo/rpm/public.key
            cat << 'EOF' | sudo tee /etc/yum.repos.d/trivy.repo
[trivy]
name=Trivy repository
baseurl=https://aquasecurity.github.io/trivy-repo/rpm/releases/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://aquasecurity.github.io/trivy-repo/rpm/public.key
EOF
            sudo dnf install -y trivy
            ;;
        apt)
            # Trivy has an official DEB repo
            sudo apt-get install -y wget apt-transport-https gnupg lsb-release
            wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo gpg --dearmor -o /usr/share/keyrings/trivy.gpg
            echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main" | sudo tee /etc/apt/sources.list.d/trivy.list
            sudo apt-get update
            sudo apt-get install -y trivy
            ;;
    esac
fi


# ════════════════════════════════════════════════════════════
#  CLOUD & INFRASTRUCTURE
# ════════════════════════════════════════════════════════════
echo "▸ Installing cloud & infrastructure tools..."

# AWS CLI v2 — S3, ECR, ECS, IAM, CloudFormation, SST deploys
# AWS doesn't publish to standard package managers — uses their own installer
if ! command -v aws &>/dev/null; then
    echo "  ▸ Installing AWS CLI v2..."
    curl -sL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip
    unzip -qo /tmp/awscliv2.zip -d /tmp
    sudo /tmp/aws/install
    rm -rf /tmp/aws /tmp/awscliv2.zip
else
    echo "  ✓ AWS CLI already installed ($(aws --version | cut -d' ' -f1))"
fi

# Tailscale — mesh VPN for secure remote access
if ! command -v tailscale &>/dev/null; then
    case $PM in
        pacman)
            sudo pacman -S --needed --noconfirm tailscale
            sudo systemctl enable --now tailscaled
            ;;
        *)
            # Official install script handles Debian/Ubuntu and Fedora
            curl -fsSL https://tailscale.com/install.sh | sh
            ;;
    esac
fi

# Docker — container runtime
if ! command -v docker &>/dev/null; then
    case $PM in
        pacman)
            sudo pacman -S --needed --noconfirm docker docker-compose
            sudo systemctl enable --now docker
            sudo usermod -aG docker "$USER"
            ;;
        dnf)
            sudo dnf install -y dnf-plugins-core
            sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
            sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
            sudo systemctl enable --now docker
            sudo usermod -aG docker "$USER"
            ;;
        apt)
            sudo apt-get install -y ca-certificates curl
            sudo install -m 0755 -d /etc/apt/keyrings
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list
            sudo apt-get update
            sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
            sudo systemctl enable --now docker
            sudo usermod -aG docker "$USER"
            ;;
    esac
    echo "  ⚠ Log out and back in for docker group membership to take effect"
fi


# ════════════════════════════════════════════════════════════
#  FONTS
# ════════════════════════════════════════════════════════════
echo "▸ Installing fonts..."

# JetBrains Mono — monospace font for terminal and editor
if ! fc-list | grep -qi "JetBrains Mono" 2>/dev/null; then
    case $PM in
        pacman)
            sudo pacman -S --needed --noconfirm ttf-jetbrains-mono ttf-jetbrains-mono-nerd
            ;;
        *)
            echo "  ▸ Installing JetBrains Mono from Nerd Fonts..."
            FONT_DIR="$HOME/.local/share/fonts"
            mkdir -p "$FONT_DIR"
            curl -sL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz" -o /tmp/JetBrainsMono.tar.xz
            tar xf /tmp/JetBrainsMono.tar.xz -C "$FONT_DIR"
            fc-cache -f
            rm -f /tmp/JetBrainsMono.tar.xz
            ;;
    esac
fi


# ════════════════════════════════════════════════════════════
#  SUMMARY
# ════════════════════════════════════════════════════════════
echo ""
echo "════════════════════════════════════════════"
echo "✓ All tools installed"
echo "════════════════════════════════════════════"
echo ""
echo "Next steps:"
echo "  cd ~/dev/dotfiles"
echo "  stow fish tmux git lazygit direnv"
echo "  # stow ghostty  (if using Ghostty on Linux)"
echo ""
echo "Then install fisher + plugins:"
echo '  fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"'
echo '  fish -c "fisher update"'
echo '  fish -c "tide configure"'
echo ""
echo "Then install languages via mise:"
echo "  mise use --global node@22"
echo "  mise use --global python@3.12"
echo "  mise use --global go@1.22"
echo "  mise use --global java@temurin-21"
echo "  mise use --global gradle@8.12"
echo "  mise use --global maven@3.9"
echo "  pip install jinja2 pyyaml   # for golden paths rendering"
echo ""
echo "Note: Linux uses inotifywait (inotify-tools) instead of fswatch."
echo "      The golden paths Makefile watch target should use inotifywait on Linux."
echo ""
if [ "$PM" = "pacman" ]; then
    echo "Arch note: lazygit, lazydocker, trivy are AUR packages."
    echo "  Install an AUR helper if you haven't: https://github.com/Jguer/yay"
fi
