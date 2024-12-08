{
  imports = [
    ./hardware-configuration.nix
    ../common/global
    ../common/users/ivo
    ../common/optinal/tailscale-ssh.nix
  ];

  boot.loader = {
    grub.enable = false;
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  services.tailscale = {
    extraUpFlags = ["--advertise-tags=tag:server"];
  };

  networking = {
    hostName = "solid-dog";
    networkmanager.enable = true;
  };

  nixpkgs.hostPlatform.system = "aarch64-linux";
  system.stateVersion = "24.11";
}
