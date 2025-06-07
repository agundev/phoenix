{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.phoenix.services.virt-manager;
in
{
  options.phoenix.services.virt-manager.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable virt-manager and libvirtd virtualization tools.";
  };

  config = lib.mkIf cfg.enable {
    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          swtpm.enable = true;
          ovmf.packages = [ pkgs.OVMFFull.fd ];
        };
      };
      spiceUSBRedirection.enable = true;
    };
    programs.virt-manager.enable = true;

    phoenix.users.extraGroups = [ "libvirtd" ];
  };
}
