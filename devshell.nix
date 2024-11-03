{
  pkgs,
  inputs,
  ...
}: let
  nvim = inputs.nixvim.packages."${pkgs.stdenv.hostPlatform.system}".default;

  pre-commit-check = inputs.pre-commit-hooks.lib."${pkgs.stdenv.hostPlatform.system}".run {
    src = ./.;
    hooks = {
      flake-checker.enable = true;
      alejandra.enable = true;
      deadnix.enable = true;
      statix.enable = true;
    };
  };
in {
  default = pkgs.mkShell {
    name = "dots";
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
    inherit (pre-commit-check) shellHook;
    buildInputs = pre-commit-check.enabledPackages;
  };
}
