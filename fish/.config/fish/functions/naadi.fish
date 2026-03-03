function naadi --description "Attach to or create naadi tmux session"
    if tmux has-session -t naadi 2>/dev/null
        tmux attach -t naadi
    else
        tmux new-session -s naadi -c ~/dev
    end
end
