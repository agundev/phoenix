{
  config,
  pkgs,
  inputs,
  ...
}:
{
  boot.plymouth = {
    enable = true;
    theme = "bgrt";
  };

  boot.initrd.verbose = false;
  boot.consoleLogLevel = 0;
  boot.kernelParams = [
    "quiet"
    "udev.log_level=0"
  ];
}
