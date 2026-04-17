{pkgs, ...}: {
  programs.mtr.enable = true;

  environment.systemPackages = with pkgs; [
    htop
    btop
    ncdu
    gdu
    tree
    usbutils
    pciutils
    nmap
    mtr
    iperf3
    wireshark
    ipcalc
    fping
  ];
}
