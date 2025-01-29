{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:

let
  cfg = config.${namespace}.nixos.nix-ld;
in
{
  options.${namespace}.nixos.nix-ld = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable nix-ld program.";
  };

  config = lib.mkIf cfg {
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
