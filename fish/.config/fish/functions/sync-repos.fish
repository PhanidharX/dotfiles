function sync-repos --description "Pull all git repos under ~/dev in parallel"
    set repos (find ~/dev -maxdepth 2 -name ".git" -type d 2>/dev/null | xargs -I{} dirname {})

    if test (count $repos) -eq 0
        echo "No git repos found under ~/dev"
        return 1
    end

    echo "Syncing "(count $repos)" repos..."

    for repo in $repos
        fish -c "
            set name (basename $repo)
            set result (git -C $repo pull --rebase 2>&1)
            echo \"[\$name] \$result\"
        " &
    end

    wait
    echo "Done."
end
