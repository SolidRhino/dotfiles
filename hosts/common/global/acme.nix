{
  # Enable acme for usage with nginx vhosts
  security.acme = {
    defaults.email = "acme@ivotrompert.nl";
    acceptTerms = true;
  };

  environment.persistence = {
    "/persistent" = {
      directories = ["/var/lib/acme"];
    };
  };
}
