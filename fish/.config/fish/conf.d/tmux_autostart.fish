# Auto-start tmux in interactive local shells
# Uncomment the set line to enable
if status is-interactive
    and not set -q TMUX
    and not set -q SSH_CONNECTION
    # set fish_tmux_autostart true
end
