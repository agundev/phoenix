{config, pkgs, inputs, ...}:

{
  imports = [
    (inputs.self + /modules/system/networking/networkmanager.nix)
    (inputs.self + /modules/system/audio/pipewire.nix)
    (inputs.self + /modules/system/cups.nix)
  ];
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
}


