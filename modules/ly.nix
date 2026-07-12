{...}: {
  flake.modules.nixos.ly = {...}: {
    services.displayManager.ly = {
      enable = true;
      settings = {
        tty = 1;
        # Désactive l'animation pour éviter le flash avec Plymouth
        animate = false;
        # Session par défaut pré-sélectionnée dans ly
        default_session = "hyprland";
      };
    };
  };
}
