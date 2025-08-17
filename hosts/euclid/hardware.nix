{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

let
  # Use older kernel
  oldPkgs =
    import
      (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/28ace32529a63842e4f8103e4f9b24960cf6c23a.tar.gz";
        sha256 = "1zphnsa5dhwgi4dsqza15cjvpi7kksidfmjkjymjninqpv04wgfc";
      })
      {
        system = pkgs.stdenv.system;
        config = pkgs.config;
      };
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ ];
  boot.initrd.kernelModules = [ ];

  boot.kernelPackages = oldPkgs.linuxKernel.packages.linux_rpi3;

  # fix the following error :
  # modprobe: FATAL: Module tpm-crb not found in directory...
  # https://github.com/NixOS/nixpkgs/issues/154163#issuecomment-1350599022
  nixpkgs.overlays = [
    (_final: super: {
      makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

  boot.kernelParams = [
    "console=ttyS1,115200n8"
    "console=tty0"
    "8250.nr_uarts=1"
  ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  # Modified overlay to set dr_mode to "host". Original overlay here: https://github.com/raspberrypi/linux/blob/rpi-6.12.y/arch/arm/boot/dts/overlays/dwc2-overlay.dts
  hardware.deviceTree = {
    filter = "*rpi*.dtb";
    overlays = [
      {
        name = "dwc2-overlay";
        dtsText = ''
          /dts-v1/;
          /plugin/;

          /{
            compatible = "brcm,bcm2837";

            fragment@0 {
              target = <&usb>;
              #address-cells = <1>;
              #size-cells = <1>;
              dwc2_usb: __overlay__ {
                compatible = "brcm,bcm2835-usb";
                dr_mode = "host";
                g-np-tx-fifo-size = <32>;
                g-rx-fifo-size = <558>;
                g-tx-fifo-size = <512 512 512 512 512 256 256>;
                status = "okay";
              };
            };
          };
        '';
      }
      {
        name = "disable-bt-overlay";
        dtsText = ''
          /dts-v1/;
          /plugin/;

          /* Disable Bluetooth and restore UART0/ttyAMA0 over GPIOs 14 & 15. */

          #include <dt-bindings/gpio/gpio.h>

          /{
            compatible = "brcm,bcm2835";

            fragment@0 {
              target = <&uart1>;
              __overlay__ {
                status = "disabled";
              };
            };

            fragment@1 {
              target = <&uart0>;
              __overlay__ {
                pinctrl-names = "default";
                pinctrl-0 = <&uart0_pins>;
                status = "okay";
              };
            };

            fragment@2 {
              target = <&bt>;
              __overlay__ {
                status = "disabled";
              };
            };

            fragment@3 {
              target = <&uart0_pins>;
              __overlay__ {
                brcm,pins;
                brcm,function;
                brcm,pull;
              };
            };

            fragment@4 {
              target = <&bt_pins>;
              __overlay__ {
                brcm,pins;
                brcm,function;
                brcm,pull;
              };
            };

            fragment@5 {
              target-path = "/aliases";
              __overlay__ {
                serial0 = "/soc/serial@7e201000";
                serial1 = "/soc/serial@7e215040";
              };
            };
          };
        '';
      }
    ];
  };

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  fileSystems."/" = {
    # Cool UUID lol
    device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/2178-694E";
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
