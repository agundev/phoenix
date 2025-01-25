{
  config,
  pkgs,
  inputs,
  ...
}:
{
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024;
      priority = 10;
    }
  ];
}
