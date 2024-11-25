{
  pkgs,
  inputs,
  ...
}: let
  #nvim = inputs.nixvim.packages."${pkgs.stdenv.hostPlatform.system}".default;
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
      # Language servers
      nixd
      nil
      yaml-language-server
      vscode-langservers-extracted

      fzf
      fd
      nushell
      just
      #nvim
      helix
    ];
    inherit (pre-commit-check) shellHook;
    buildInputs = pre-commit-check.enabledPackages;
  };
}
