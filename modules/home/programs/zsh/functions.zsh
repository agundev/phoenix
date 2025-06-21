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

dply() {
    deploy -sk --auto-rollback false .#$1
}

x() {
nix run nixpkgs#$1 -- ${@:2}
}

s() {
  local args=()
  for pkg in $@; do
    args+=("nixpkgs#$pkg")
  done
  nix shell ${args[@]}
}

alias sd="sudo "
alias upd="nix flake update --flake /etc/nixos"
alias udp="upd && dply"
alias cc="nix-collect-garbage"
alias cca="sa cc ; cc"
alias cpg="cc -d"
alias cpga="sa cpg ; cpg"