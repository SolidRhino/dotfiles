{
  pkgs ? import <nixpkgs> {},
  nixvim ? import (builtins.fetchGit {url = "https://github.com/SolidRhino/nixvim";}),
  ...
}: let
  nixvim' = nixvim.packages."${pkgs.stdenv.hostPlatform.system}".default;
  nvim = nixvim';
in {
  default = pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes ca-derivations";
    nativeBuildInputs = with pkgs; [
      bashInteractive
      gcc
      alejandra
      deadnix
      statix
      nix-inspect
      nodePackages.prettier
      nix
      home-manager
      git
      lazygit

      sops
      ssh-to-age
      gnupg
      age

      fzf
      fd
      nushell
      just
      nvim
    ];
    name = "dots";
  };
}
