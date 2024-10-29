{pkgs ? import <nixpkgs> {}, ...}: {
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
      helix
    ];
    name = "dots";
  };
}
