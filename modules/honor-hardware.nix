{...}: {
  flake.modules.nixos.honor-hardware = {
    config,
    lib,
    pkgs,
    modulesPath,
    ...
  }: let
    dsdtUrl = "https://github.com/denis-bb/honor-fmb-p-dsdt/raw/refs/heads/master/dsdt.global.aml";
    customDsdt = pkgs.fetchurl {
      url = dsdtUrl;
      hash = "sha256-GdGlyy9dzWi2qkHOV468PVyrjw+9XVCI+05MerYK9e4=";
    };
  in {
    imports = [(modulesPath + "/installer/scan/not-detected.nix")];

    boot = {
      initrd = {
        availableKernelModules = ["xhci_pci" "nvme" "usb_storage" "usbhid" "sd_mod" "i2c_hid" "hid_multitouch" "xe"];
        kernelModules = ["kvm-intel" "i2c_hid" "hid_multitouch" "xe"];
        prepend = [
          "${pkgs.runCommand "dsdt-overlay" {
              nativeBuildInputs = [pkgs.cpio];
            } ''
              mkdir -p root/kernel/firmware/acpi
              cp ${customDsdt} root/kernel/firmware/acpi/DSDT.aml
              cd root
              find . | cpio -o -H newc > $out
            ''}"
        ];
      };
      kernelModules = ["kvm-intel" "i2c_hid" "hid_multitouch" "xe"];
      kernelParams = [
        "snd-hda-intel.model=generic"
        "pci=norcs"
        "snd-intel-dspcfg.dsp_driver=3"
        "xe.force_probe=7d51"
        "mitigations=off"
      ];
    };

    services.xserver.videoDrivers = ["modesetting"];

    hardware = {
      firmware = [pkgs.linux-firmware];
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          intel-media-driver
          vpl-gpu-rt
          intel-compute-runtime
        ];
      };
    };

    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
    };

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
