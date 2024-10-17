{
  programs = {
    atuin = {
      enable = true;
      settings = {
        sync = {
          records = true;
          auto_sync = true;
          sync_frequency = "0";
        };
        daemon.enabled = true;
      };
    };
  };
}
