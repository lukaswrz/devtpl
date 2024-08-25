let
  appName = "example";
in {
  languages.javascript = {
    enable = true;
    npm = {
      enable = true;
      install.enable = true;
    };
  };

  services.postgres = {
    enable = true;
    initialDatabases = [{name = appName;}];
    initialScript = ''
      CREATE USER "${appName}" WITH ENCRYPTED PASSWORD '${appName}';
      GRANT ALL PRIVILEGES ON DATABASE "${appName}" TO "${appName}";
    '';
  };
}
