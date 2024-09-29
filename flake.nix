{
  description = "A few development environments and tools for generating them";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    devenv.url = "github:cachix/devenv";
    treefmt.url = "github:numtide/treefmt-nix";
    devenv-root = {
      url = "file+file:///dev/null";
      flake = false;
    };
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = {
    self,
    nixpkgs,
    flake-parts,
    devenv,
    treefmt,
    devenv-root,
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        devenv.flakeModule
        treefmt.flakeModule

        ./treefmt.nix
      ];

      systems = nixpkgs.lib.systems.flakeExposed;

      perSystem = {
        pkgs,
        system,
        ...
      }: {
        devenv.shells.default = {
          imports = [./devenv.nix];

          devenv.root = let
            devenvRootFileContent = builtins.readFile devenv-root.outPath;
          in
            pkgs.lib.mkIf (devenvRootFileContent != "") devenvRootFileContent;
        };

        packages.default = pkgs.writers.writePython3Bin "gen" {flakeIgnore = ["E501"];} ./gen.py;
      };

      flake.templates = nixpkgs.lib.pipe ./templates.json [
        builtins.readFile
        builtins.fromJSON
      ];
    };
}
