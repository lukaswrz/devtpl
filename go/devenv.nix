{pkgs, ...}: let
  appName = "example";
in {
  packages = [pkgs.air];

  languages.go.enable = true;

  services.postgres = {
    enable = true;
    initialDatabases = [{name = appName;}];
  };
}
