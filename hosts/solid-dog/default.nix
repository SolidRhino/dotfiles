{
  imports = [
    ./hardware-configuration.nix
    ../common/global
    ../common/users/ivo
    ../common/optinal/tailscale-ssh.nix
  ];

  services.tailscale = {
    extraUpFlags = ["--advertise-tags=tag:server"];
  };

  networking = {
    hostName = "solid-dog";
  };

  nixpkgs.hostPlatform.system = "aarch64-linux";
  system.stateVersion = "24.11";
}
