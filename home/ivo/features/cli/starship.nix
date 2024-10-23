{
  programs = {
    starship = {
      enable = true;
      enableTransience = true;
      settings = {
        add_newline = true;
        aws.disabled = true;
        gcloud.disabled = true;
        container.disabled = true;
      };
    };
  };
}
