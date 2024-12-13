{
  pkgs,
  config,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users.mutableUsers = false;
  users.users.ivo = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = ifTheyExist [
      "audio"
      "deluge"
      "docker"
      "git"
      "i2c"
      "libvirtd"
      "lxd"
      "minecraft"
      "mysql"
      "network"
      "plugdev"
      "podman"
      "video"
      "wheel"
      "wireshark"
    ];

    #openssh.authorizedKeys.keys = lib.splitString "\n" (builtins.readFile ../../../../home/ivo/ssh.pub);
    hashedPasswordFile = config.sops.secrets.ivo-password.path;
    packages = [pkgs.home-manager];
  };

  sops.secrets.ivo-password = {
    sopsFile = ../../secrets.yaml;
    neededForUsers = true;
  };

  home-manager.users.ivo = import ../../../../home/ivo/${config.networking.hostName}.nix;
}
