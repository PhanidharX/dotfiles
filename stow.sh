#!/usr/bin/env bash
set -e

# ──────────────────────────────────────────────────────────
# stow.sh — reads Stowfile, stows all listed packages
#
# Usage:
#   ./stow.sh              Stow all packages
#   ./stow.sh --restow     Remove and re-create all symlinks
#   ./stow.sh --delete     Remove all symlinks
#   ./stow.sh --dry-run    Show what would happen
# ──────────────────────────────────────────────────────────

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
STOWFILE="$DOTFILES_DIR/Stowfile"

if [ ! -f "$STOWFILE" ]; then
    echo "✗ Stowfile not found at $STOWFILE" && exit 1
fi

# Parse flags
STOW_FLAGS=("-v" "-t" "$HOME")
ACTION="stow"

for arg in "$@"; do
    case $arg in
        --restow|-R)  STOW_FLAGS+=("-R"); ACTION="restow" ;;
        --delete|-D)  STOW_FLAGS+=("-D"); ACTION="unstow" ;;
        --dry-run|-n) STOW_FLAGS+=("-n"); ACTION="dry-run" ;;
        *)            echo "Unknown flag: $arg"; exit 1 ;;
    esac
done

# Read packages from Stowfile (skip comments and blank lines)
PACKAGES=()
while IFS= read -r line; do
    pkg=$(echo "$line" | sed 's/#.*//' | xargs)
    [ -n "$pkg" ] && PACKAGES+=("$pkg")
done < "$STOWFILE"

if [ ${#PACKAGES[@]} -eq 0 ]; then
    echo "✗ No packages found in Stowfile" && exit 1
fi

echo "▸ ${ACTION^}ing ${#PACKAGES[@]} packages from Stowfile..."
echo ""

cd "$DOTFILES_DIR"

for pkg in "${PACKAGES[@]}"; do
    if [ -d "$pkg" ]; then
        echo "  ▸ $pkg"
        stow "${STOW_FLAGS[@]}" "$pkg"
    else
        echo "  ⚠ $pkg/ directory not found — skipping"
    fi
done

echo ""
echo "✓ Done"

# ─── Bootstrap: one-time installs that can't be stowed ───
# Skip during dry-run or delete
if [[ "$ACTION" != "dry-run" && "$ACTION" != "unstow" ]]; then
    # TPM — Tmux Plugin Manager
    TPM_DIR="$HOME/.tmux/plugins/tpm"
    if [ ! -d "$TPM_DIR" ]; then
        echo ""
        echo "▸ Installing TPM (Tmux Plugin Manager)..."
        git clone --depth=1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
        echo "  ✓ TPM installed — open tmux and press prefix+I to install plugins"
    fi
fi
