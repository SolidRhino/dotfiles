{
  pkgs,
  config,
  ...
}: {
  programs.gh = {
    enable = true;
    extensions = with pkgs; [gh-eco gh-poi gh-s gh-markdown-preview];
    settings = {
      version = "1";
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };
  home.persistence = {
    "/persist/${config.home.homeDirectory}".files = [".config/gh/hosts.yml"];
  };
}
