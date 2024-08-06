{pkgs, ...}: let
  appName = "example";
in {
  languages.go.enable = true;

  languages.rust = {
    enable = true;
    channel = "nightly";

    components = ["rustc" "cargo" "clippy" "rustfmt" "rust-analyzer"];
  };

  services.postgresql = {
    enable = true;
    initialDatabases = [{name = appName;}];
  };
}
