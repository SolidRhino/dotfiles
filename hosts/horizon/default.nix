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
    hostName = "horizon";
  };
  nixpkgs.hostPlatform.system = "x86_64-linux";
  system.stateVersion = "24.11";
}
