{
  config,
  lib,
  pkgs,
  inputs,
  hardware,
  ...
}:

let
  cfg = config.phoenix.nixos.appimage;
in
{
  options.phoenix.nixos.appimage.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable AppImage support.";
  };

  config = lib.mkIf cfg.enable {
    programs.appimage = {
      enable = true;
      package = pkgs.appimage-run.override {
        extraPkgs = pkgs: [ pkgs.libxcrypt-legacy ];
      };
      binfmt = true;
    };
  };
}
