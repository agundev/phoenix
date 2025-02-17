{
  config,
  lib,
  
  ...
}:

let
  cfg = config.phoenix.audio.pipewire;
in
{
  options.phoenix.audio.pipewire = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable PipeWire audio configuration.";
  };

  config = lib.mkIf cfg {
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
