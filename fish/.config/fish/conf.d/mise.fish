# Activate mise — polyglot version manager for node, python, go, java, etc.
# Replaces nvm, pyenv, SDKMAN with a single tool.
if test -x ~/.local/bin/mise
    ~/.local/bin/mise activate fish | source
else if command -q mise
    mise activate fish | source
end
