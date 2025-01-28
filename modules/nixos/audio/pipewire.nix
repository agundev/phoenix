{ config, lib, namespace, ... }:

with lib;

let
  cfg = config.${namespace}.audio.pipewire;
in
{
  options.${namespace}.audio.pipewire = mkOption {
    type = types.bool;
    default = false;
    description = "Enable PipeWire audio configuration.";
  };

  config = mkIf cfg {
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };
}
