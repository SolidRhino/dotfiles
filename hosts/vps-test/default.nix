{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./vpsadminos.nix
    ../common/global
    ../common/users/ivo
    ../common/optinal/tailscale-ssh.nix
  ];

  services.tailscale = {
    extraUpFlags = ["--advertise-tags=tag:server"];
  };

  networking = {
    hostName = "vps-test";
  };

  nixpkgs.hostPlatform.system = "x86_64-linux";
  system.stateVersion = "24.11";
}
