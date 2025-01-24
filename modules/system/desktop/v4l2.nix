{config, pkgs, inputs, ...}:
{
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=0
  '';

  environment.systemPackages = with pkgs; [ config.boot.kernelPackages.v4l2loopback.bin v4l-utils ];
}