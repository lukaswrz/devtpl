{pkgs, ...}: let
  appName = "example";
in {
  packages = [pkgs.air];

  languages.go.enable = true;

  services.postgresql = {
    enable = true;
    initialDatabases = [{name = appName;}];
  };
}
