{ config, pkgs, inputs, ... }:

{
  imports = [
    (inputs.self + /modules/home/shell/zsh.nix)
  ];

  home.username = "advaith";
  home.homeDirectory = "/home/advaith";

  home.packages = with pkgs; [
    fastfetch
    brave
    micro
    
    # archives
    zip
    xz
    unzip
    p7zip
    ripgrep

    # networking
    dnsutils
    nmap
    gping

    # misc
    cowsay
    file
    which
    tree
    gawk
    zstd
    gnupg

    # system tools
    sysstat
    lm_sensors
    ethtool
    pciutils
    usbutils
  ];

  # shell
  programs.git = {
    enable = true;
    userName = "geodic";
    userEmail = "geodic.github@proton.me";
  };

  # apps
  programs.vscode.enable = true;

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
