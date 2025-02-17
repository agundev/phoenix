alias home-manager="home-manager --flake /etc/nixos"
alias hs="home-manager switch"
alias rso="nixos apply -y"
alias rs="rso -y && hs"
alias upd="nix flake update --flake /etc/nixos"
alias uhs="upd && hs"
alias urso="upd && rso"
alias urs="upd && rs"
alias cc="nix-collect-garbage"
alias cpg="cc -d"
alias cpga="sudo cpg && cpg"

mkcd() {
    mkdir -p "$1" && cd "$1"
}

codenv() {
    local dir=$(realpath "$1")
    if nix develop "$dir" -c true; then
        nix develop "$dir" -c code "$dir"
    else
        echo "Warning: Failed to initialize developer environment for '$dir'"
        code "$dir"
    fi
}