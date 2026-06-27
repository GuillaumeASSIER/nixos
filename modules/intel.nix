{...}: {
  flake.modules.nixos.intel = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      nvtopPackages.intel
      inteltool
      igsc
      haskellPackages.intel-powermon
    ];
  };
}
