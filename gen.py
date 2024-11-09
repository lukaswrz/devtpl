from pathlib import Path
from string import Template as TextTemplate
from enum import Enum
import tomllib as toml
import json
import shutil


FLAKE_FILE_TEMPLATE = """\
{
  description = "$description";

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

        packages.default = pkgs.callPackage ./package.nix {};
      };
    };
}
"""


ENVRC_CONTENTS = """\
nix_direnv_watch_file flake.nix
nix_direnv_watch_file flake.lock

DEVENV_ROOT_FILE="$(mktemp)"
printf %s "$PWD" > "$DEVENV_ROOT_FILE"
if ! use flake . --override-input devenv-root "file+file://$DEVENV_ROOT_FILE"
then
  echo "devenv could not be built. The devenv environment was not loaded. Make the necessary changes to devenv.nix and hit enter to try again." >&2
fi
"""


def nix_esc(raw: str) -> str:
    class State(Enum):
        START = 1
        SUBST = 2

    result = ""
    prev = []

    state = State.START

    for char in list(raw):
        match state:
            case State.START:
                match char:
                    case "\\":
                        result += "\\\\"
                    case '"':
                        result += '\\"'
                    case "$":
                        prev.append(char)
                        state = State.SUBST
                    case _:
                        result += char

            case State.SUBST:
                match char:
                    case "{":
                        result += "\\" + "".join(prev) + char
                        state = State.START
                    case _:
                        result += char
                state = State.START

    return result


class TemplateMeta:
    description: str
    welcome_text: str | None

    def __init__(self, description: str, welcome_text: str | None):
        self.description = description
        self.welcome_text = welcome_text

    def to_nix(self, path: str):
        return ''.join([
            "{",
            f'path=./.+"/{nix_esc(path)}";',
            f'description="{nix_esc(template_meta.description)}";',
            f'welcomeText="{nix_esc(template_meta.welcome_text)}";' if self.welcome_text is not None else "",
            "}",
        ])


if __name__ == "__main__":
    templates: dict[str, dict[str, str]] = {}

    for src in Path("src").iterdir():
        if not src.is_dir():
            continue
        copy_dir = src / "copy"
        if not copy_dir.is_dir():
            raise FileNotFoundError(str(copy_dir))

        name = src.name

        dst = Path(name)
        if dst.exists():
            if not dst.is_dir():
                raise FileNotFoundError(str(dst))
            shutil.rmtree(dst)

        with (src / "meta.toml").open(mode="rb") as fp:
            meta = toml.load(fp)
            description = meta.get("description", "Development environment")
            welcome_text = meta.get("welcome_text", None)
            templates[name] = {
                "description": description,
                "path": f"./{name}"
            }
            templates[name]["description"] = description
            if welcome_text is not None:
                templates[name]["welcomeText"] = welcome_text

        shutil.copytree((src / "copy"), dst)

        (dst / "flake.nix").write_text(
            TextTemplate(FLAKE_FILE_TEMPLATE).safe_substitute(description=description)
        )
        (dst / ".envrc").write_text(ENVRC_CONTENTS)
        Path(".envrc").write_text(ENVRC_CONTENTS)

    with Path("templates.json").open(mode="w") as fp:
        json.dump(templates, fp, indent=2)
        fp.write("\n")
