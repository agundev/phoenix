{
  config,
  lib,
  pkgs,  
  ...
}:

{
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    acl
    attr
    bzip2
    dbus
    expat
    fontconfig
    freetype
    fuse3
    icu
    libnotify
    libsodium
    libssh
    libunwind
    libusb1
    libuuid
    nspr
    nss
    stdenv.cc.cc
    ncurses5
    util-linux
    zlib
    zstd
  ];
}
