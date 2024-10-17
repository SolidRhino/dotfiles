{
  pkgs ? import <nixpkgs> {},
  inputs,
  ...
}: let
  nixvim' = inputs.nixvim.packages.${pkgs.system}.default;
  nvim = nixvim'.extend {
    config.theme = pkgs.lib.mkForce "tokyonight";
  };
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
