{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ ];
  boot.initrd.kernelModules = [ ];

  boot.kernelPackages = lib.mkDefault pkgs.linuxKernel.packages.linux_rpi3;

  # fix the following error :
  # modprobe: FATAL: Module ahci not found in directory
  # https://github.com/NixOS/nixpkgs/issues/154163#issuecomment-1350599022
  nixpkgs.overlays = [
    (_final: super: {
      makeModulesClosure = x:
        super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

  boot.kernelParams = [ "console=null" ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  boot.loader.systemd-boot.extraFiles = {
    "config.txt" = pkgs.writeTextFile {
      name = "config.txt";
      text = ''
        # For more information see https://www.raspberrypi.com/documentation/computers/config_txt.html
        [all]

        # EFI
        arm_control=0x200
        armstub=RPI_EFI.fd
        disable_commandline_tags=2
        device_tree_address=0x1f0000
        device_tree_end=0x200000

        # Serial
        enable_uart=1
        dtoverlay=disable-bt
      '';
    };
  };

  services.udev.extraRules =
    let shell = "${pkgs.bash}/bin/bash";
    in ''
      # https://raw.githubusercontent.com/RPi-Distro/raspberrypi-sys-mods/master/etc.armhf/udev/rules.d/99-com.rules
      KERNEL=="ttyAMA[0-9]*|ttyS[0-9]*", PROGRAM="${shell} -c '\
              ALIASES=/proc/device-tree/aliases; \
              TTYNODE=$$(readlink /sys/class/tty/%k/device/of_node | sed 's/base/:/' | cut -d: -f2); \
              if [ -e $$ALIASES/bluetooth ] && [ $$TTYNODE/bluetooth = $$(strings $$ALIASES/bluetooth) ]; then \
                  echo 1; \
              elif [ -e $$ALIASES/console ]; then \
                  if [ $$TTYNODE = $$(strings $$ALIASES/console) ]; then \
                      echo 0;\
                  else \
                      exit 1; \
                  fi \
              elif [ $$TTYNODE = $$(strings $$ALIASES/serial0) ]; then \
                  echo 0; \
              elif [ $$TTYNODE = $$(strings $$ALIASES/serial1) ]; then \
                  echo 1; \
              else \
                  exit 1; \
              fi \
      '", SYMLINK+="serial%c"
    '';

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/d0aec199-8305-4553-92ec-b4868d956265";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/7D57-461B";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;
}
