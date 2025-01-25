{
  config,
  pkgs,
  inputs,
  ...
}:
{
  users.groups.nixos = { };
  systemd.tmpfiles.settings."99-nixos" = {
    "/etc/nixos".Z = {
      group = "nixos";
      mode = "0775";
      user = "root";
    };
  };
}
