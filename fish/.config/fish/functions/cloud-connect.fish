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

function fly-install --description "Download fly CLI from a Concourse server and install as fly-<version>"
    if test (count $argv) -lt 2
        echo "Usage: fly-install <version> <concourse-url>"
        echo "Example: fly-install 7.11.0 https://ci.example.com"
        return 1
    end

    set version $argv[1]
    set url $argv[2]
    set dest ~/bin/fly-$version

    mkdir -p ~/bin
    echo "Downloading fly $version from $url ..."
    curl -fsSL "$url/api/v1/cli?arch=amd64&platform=darwin" -o $dest
    and chmod +x $dest
    and echo "Installed: $dest"
    and echo "Run with: fly-$version"
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
