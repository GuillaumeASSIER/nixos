{lib, ...}: {
  options = {
    heap.email = lib.mkOption {
      type = lib.types.str;
      default = builtins.getEnv "HEAP_EMAIL";
    };

    guillaume.email = lib.mkOption {
      type = lib.types.str;
      default = builtins.getEnv "GUILLAUME_EMAIL";
    };

    openwebui.apiUrl = lib.mkOption {
      type = lib.types.str;
      default = builtins.getEnv "OPENWEBUI_API_URL";
    };

    openwebui.apiKey = lib.mkOption {
      type = lib.types.str;
      default = builtins.getEnv "OPENWEBUI_API_KEY";
    };

    vates.gitHost = lib.mkOption {
      type = lib.types.str;
      default = builtins.getEnv "VATES_GIT_HOST";
    };
  };

  config.systems = ["x86_64-linux"];
}
