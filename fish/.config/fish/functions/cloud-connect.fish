function aws-login --description "fzf picker over AWS profiles → aws sso login"
    if not command -q aws
        echo "aws CLI not found"
        return 1
    end
    if not command -q fzf
        echo "fzf not found"
        return 1
    end

    set profile (grep '^\[profile ' ~/.aws/config 2>/dev/null \
        | sed 's/^\[profile //' | sed 's/\]$//' \
        | fzf --prompt="AWS profile: " --height=40% --reverse)

    if test -z "$profile"
        return 0
    end

    echo "Logging in to profile: $profile"
    aws sso login --profile $profile
end

function kctx --description "fzf picker over kubectl contexts → switch context → launch k9s"
    if not command -q kubectl
        echo "kubectl not found"
        return 1
    end
    if not command -q fzf
        echo "fzf not found"
        return 1
    end

    set ctx (kubectl config get-contexts --no-headers 2>/dev/null \
        | awk '{print $2}' \
        | fzf --prompt="K8s context: " --height=40% --reverse)

    if test -z "$ctx"
        return 0
    end

    kubectl config use-context $ctx
    and command -q k9s; and k9s
end
