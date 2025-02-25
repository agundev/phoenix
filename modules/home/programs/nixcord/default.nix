{
  config,
  lib,
  ...
}:

let
  cfg = config.phoenix.programs.nixcord;
in
{
  options.phoenix.programs.nixcord = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Vesktop through Nixcord";
  };

  config = lib.mkIf cfg {
    programs.nixcord = {
      enable = true;
      discord.enable = false;
      vesktop.enable = true;
      config = {
        plugins = {
          alwaysAnimate.enable = true;
          anonymiseFileNames.enable = true;
          USRBG.enable = true;
          webKeybinds.enable = true;
          fakeNitro.enable = true;
          webScreenShareFixes.enable = true;
          youtubeAdblock.enable = true;
        };
      };
    };
  };
}
