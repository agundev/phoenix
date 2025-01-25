{config, pkgs, inputs, ...}:
{
  zramSwap = {
    enable = true;
    memoryPercent = 75;
    priority = 100;
  };
}