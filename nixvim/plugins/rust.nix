{
  plugins.rustaceanvim = {
    enable = true;
    settings.server.default_settings = {
      "rust-analyzer" = {
        cargo = {
          allFeatures = true;
          loadOutDirsFromCheck = true;
          runBuildScripts = true;
        };
        procMacro = {
          enable = true;
        };
      };
    };
  };
}
