{
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  boot = {
    initrd = {
      availableKernelModules = ["xhci_pci" "uas"];
      kernelModules = [];
      postDeviceCommands = lib.mkAfter ''
        zfs rollback -r zpool/root@blank
      '';
    };
    kernelModules = [];
    extraModulePackages = [];
    supportedFilesystems = ["zfs"];
  };

  fileSystems = {
    "/" = {
      device = "zroot/root";
      fsType = "zfs";
      options = ["zfsutil"];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/C5C7-03B8";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };
    "/nix" = {
      device = "zroot/nix";
      fsType = "zfs";
      options = ["zfsutil"];
    };
    "/persist" = {
      device = "zroot/persist";
      fsType = "zfs";
      options = ["zfsutil"];
      neededForBoot = true;
    };
  };

  swapDevices = [
    {device = "/dev/sda2";}
  ];

  networking.hostId = "f9608cfb";
  networking.useDHCP = lib.mkDefault true;
}
