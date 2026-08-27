{...}: {
  flake.modules.nixos.qemu = {pkgs, ...}: {
    virtualisation.libvirtd.qemu = {
      swtpm.enable = true;
    };

    environment.systemPackages = with pkgs; [
      qemu_kvm
    ];
  };
}
