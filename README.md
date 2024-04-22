# devtpl

Flake templates for some of the stacks that I use.

## Usage

### Initialize in an existing project

```bash
nix flake init --template github:lukaswrz/devtpl#template
```

### Create a new project

```bash
nix flake new --template github:lukaswrz/devtpl#template example
```

## `.gitignore`

```bash
cat <<EOF >> .gitignore
.direnv/
.devenv/
EOF
```
