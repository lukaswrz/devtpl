{pkgs, ...}: let
  appName = "example";
in {
  packages = [pkgs.air];

  languages.go.enable = true;

  services.postgres = {
    enable = true;
    initialDatabases = [{name = appName;}];
    initialScript = ''
      CREATE USER "${appName}" WITH ENCRYPTED PASSWORD '${appName}';
      GRANT ALL PRIVILEGES ON DATABASE "${appName}" TO "${appName}";
    '';
  };
}
