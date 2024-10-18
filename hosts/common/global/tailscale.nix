{lib, config, ...}: {
  services.tailscale = {
    enable = true;
    useRoutingFeatures = lib.mkDefault "client";
    authKeyFile = config.sops.secrets.tailscale-auth.path;
  };

  sops.secrets.tailscale-auth.sopsFile = ../secrets.yaml;

  environment.persistence = {
    "/persistent".directories = ["/var/lib/tailscale"];
  };
}
