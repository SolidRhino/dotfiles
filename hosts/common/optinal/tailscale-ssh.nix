{
  imports = [../global/tailscale.nix];
  services.tailscale = {
    extraUpFlags = ["--ssh"];
  };
}
