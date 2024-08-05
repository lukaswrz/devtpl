{
  config,
  pkgs,
  ...
}: {
  packages = [pkgs.nodejs];

  languages.javascript = {
    enable = true;
    npm = {
      enable = true;
      install = true;
    };
  };
}
