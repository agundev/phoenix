{ config, lib, namespace, ... }:

with lib;

let
  cfg = config.${namespace}.programs.nix-ld;
in
{
  options.${namespace}.programs.nix-ld = mkOption {
    type = types.bool;
    default = false;
    description = "Enable nix-ld program.";
  };

  config = mkIf cfg {
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
  };
}
