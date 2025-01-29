mkcd() {
    mkdir -p "$1" && cd "$1"
}

codenv() {
    local path=$(realpath "$1")
    if nix develop "$path" -c true; then
        nix develop "$path" -c code "$path"
    else
        echo "Warning: Failed to initialize developer environment for '$path'"
        code "$path"
    fi
}