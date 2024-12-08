{
  pkgs,
  inputs,
  ...
}: let
  nvim = inputs.nixvim.packages."${pkgs.stdenv.hostPlatform.system}".default;
  helix = inputs.helix.packages."${pkgs.stdenv.hostPlatform.system}".default;

  pre-commit-check = inputs.pre-commit-hooks.lib."${pkgs.stdenv.hostPlatform.system}".run {
    src = ./.;
    hooks = {
      flake-checker.enable = true;
      detect-private-keys.enable = true;
      detect-aws-credentials.enable = true;
      check-added-large-files.enable = true;
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
      alejandra
      bashInteractive
      deadnix
      gcc
      git
      home-manager
      lazygit
      nix
      nix-inspect
      nodePackages.prettier
      statix

      # encryption tools
      age
      gnupg
      sops
      ssh-to-age

      # Language servers
      bash-language-server
      nil
      nixd
      vscode-langservers-extracted
      yaml-language-server

      fd
      fzf
      just
      nushell

      # Editors
      helix
      nvim
    ];
    inherit (pre-commit-check) shellHook;
    buildInputs = pre-commit-check.enabledPackages;
  };
}
