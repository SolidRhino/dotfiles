{pkgs, ...}: {
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  environment.persistence = {
    "/persistent".directories = ["/var/lib/mysql"];
  };
}
