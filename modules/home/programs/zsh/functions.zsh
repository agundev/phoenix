alias home-manager="home-manager --flake /etc/nixos"
alias hs="home-manager switch"
alias rs="sudo nixos-rebuild switch && hs"
alias rso="sudo nixos-rebuild switch"
alias upd="nix flake update --flake /etc/nixos"
alias uhs="upd && hs"
alias urs="upd && sudo nixos-rebuild switch && hs"
alias urso="upd && sudo nixos-rebuild switch"
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