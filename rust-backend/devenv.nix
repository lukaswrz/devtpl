let
  appName = "example";
in {
  languages.rust = {
    enable = true;
    channel = "nightly";

    components = ["rustc" "cargo" "clippy" "rustfmt" "rust-analyzer"];
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
