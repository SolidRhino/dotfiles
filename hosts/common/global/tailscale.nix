{lib, ...}: {
  services.tailscale = {
    enable = true;
    useRoutingFeatures = lib.mkDefault "client";
  };

  environment.persistence = {
    "/persist".directories = ["/var/lib/tailscale"];
  };
}
