{
  services.hermes-agent = {
    enable = true;
    settings.model.default = "openrouter/free";
    environmentFiles = ["/var/lib/hermes/.env"];
    addToSystemPackages = true;
  };
}