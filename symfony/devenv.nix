{
  lib,
  pkgs,
  ...
}: let
  appName = "example";
in {
  packages = [pkgs.symfony-cli];

  languages.php = {
    enable = true;
    ini = ''
      memory_limit = 128M
      display_errors = On
      error_reporting = E_ALL
      xdebug.mode = debug
      xdebug.discover_client_host = 1
      xdebug.client_host = localhost
    '';
  };

  services = {
    mysql = {
      enable = true;
      package = pkgs.mariadb;
      initialDatabases = [{name = appName;}];
      ensureUsers = [
        {
          name = appName;
          password = appName;
          ensurePermissions = {
            "${appName}.*" = "ALL PRIVILEGES";
          };
        }
      ];
    };

    adminer = {
      enable = true;
      package = pkgs.adminerevo;
      listen = "localhost:8001";
    };
  };

  processes.symfony.exec = "${lib.getExe pkgs.symfony-cli} server:start --port 8000";

  env.APP_ENV = "dev";

  dotenv.enable = true;
}
