function git-open --description "Open current git repo in browser"
    set remote (git remote get-url origin 2>/dev/null)
    if test -z "$remote"
        echo "No git remote 'origin' found"
        return 1
    end

    # Convert SSH to HTTPS
    # git@github.com:user/repo.git  →  https://github.com/user/repo
    # git@bitbucket.org:user/repo.git  →  https://bitbucket.org/user/repo
    set url (echo $remote \
        | sed 's|^git@\([^:]*\):\(.*\)\.git$|https://\1/\2|' \
        | sed 's|^git@\([^:]*\):\(.*\)$|https://\1/\2|' \
        | sed 's|\.git$||')

    echo "Opening: $url"

    if command -q open
        open $url
    else if command -q xdg-open
        xdg-open $url
    else
        echo "Cannot open browser. URL: $url"
        return 1
    end
end
