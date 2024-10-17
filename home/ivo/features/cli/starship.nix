{
  programs = {
    starship = {
      enable = true;
      enableTransience = true;
      settings = {
        add_newline = true;
        aws.disable = true;
        gcloud.disable = true;
      };
    };
  };
}
