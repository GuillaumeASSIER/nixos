{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: let
  # God bless Denis
  # https://github.com/denis-bb/honor-fmb-p-dsdt
  dsdtUrl = "https://github.com/denis-bb/honor-fmb-p-dsdt/raw/refs/heads/master/dsdt.global.aml";
  customDsdt = pkgs.fetchurl {
    url = dsdtUrl;
    hash = "sha256-GdGlyy9dzWi2qkHOV468PVyrjw+9XVCI+05MerYK9e4=";
  };
in {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

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
      # Désactive les mitigations CPU pour améliorer les performances (portable sur secteur)
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

  # disko.devices = {
  #   disk.nvme0n1 = {
  #     device = "/dev/nvme0n1";
  #     type = "disk";
  #     content = {
  #       type = "gpt";
  #       partitions = {
  #           ESP = {
  #             size = "1G";
  #             type = "EF00";
  #             content = {
  #               type = "filesystem";
  #               format = "vfat";
  #               mountpoint = "/boot";
  #               mountOptions = [ "fmask=0077" "dmask=0077" ];
  #             };
  #           };
  #         luks = {
  #           size = "100%";
  #           type = "8309";
  #           content = {
  #             type = "luks";
  #             name = "cryptroot";
  #             extraOpenArgs = [ "--allow-discards" ];
  #             content = {
  #               type = "btrfs";
  #               subvolumes = {
  #                 "/root" = {
  #                   mountpoint = "/";
  #                   mountOptions = [ "compress=zstd" "noatime" ];
  #                 };
  #                 "/home" = {
  #                   mountpoint = "/home";
  #                   mountOptions = [ "compress=zstd" "noatime" ];
  #                 };
  #                 "/var/log" = {
  #                   mountpoint = "/var/log";
  #                   mountOptions = [ "compress=zstd" "noatime" ];
  #                 };
  #                 "/nix" = {
  #                   mountpoint = "/nix";
  #                   mountOptions = [ "compress=zstd" "noatime" ];
  #                 };
  #               };
  #             };
  #           };
  #         };
  #       };
  #     };
  #   };
  # };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/f56a35c1-7cf7-4cd0-84d7-bad4e5e7e0ca";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/7C6B-B4BE";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/724ae94f-9d67-4192-95d2-777ed6b72fb4";}
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
