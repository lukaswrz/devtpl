{pkgs, ...}: let
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
  };
}
