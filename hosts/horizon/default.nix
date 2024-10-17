{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./vpsadminos.nix
    ../common/global
    ../common/users/ivo
  ];

  networking = {
    hostName = "horizon";
  };
  nixpkgs.hostPlatform.system = "x86_64-linux";
  system.stateVersion = "24.11";
}
