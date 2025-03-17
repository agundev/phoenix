{
  config,
  lib,
  inputs,
  pkgs,
  system,
  ...
}:

{
  phoenix = {
    desktop = {
      gnome = true;
    };
    programs = {
      ghostty = true;
      git = true;
      vscode = true;
      zsh = true;
      direnv = true;
      nixcord = true;
      _1password = true;
    };
  };

  home.packages = with pkgs; [
    # apps
    fastfetch
    brave
    inputs.zen-browser.packages."${system}".twilight
    micro
    spotify
    signal-desktop
    notion-app-enhanced

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

    # fonts
    nerd-fonts.fira-code

    # nix
    nixd
    nixfmt-rfc-style
    cachix
  ];

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";
}
