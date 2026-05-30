# dc — Docker Compose Project Switcher

[![Shell](https://img.shields.io/badge/shell-bash-89e051?style=flat-square&logo=gnubash&logoColor=white)](https://www.gnu.org/software/bash/)
[![License](https://img.shields.io/badge/license-MIT-blue?style=flat-square)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-linux%20%7C%20macos-lightgrey?style=flat-square)](#requirements)

A tiny bash wrapper that lets you run `docker compose` against any registered project — **from anywhere on your machine**. No more `cd`'ing into project folders just to restart a stack.

```bash
# Anywhere on your filesystem:
dc my-api up -d           # start the my-api stack
dc my-api logs -f web     # tail web service logs
dc my-api down            # stop it
```

Comes with **bash completion** for both project names and docker compose subcommands.

## How it works

`dc` keeps a registry of resolved Docker Compose files in `~/.config/dc/yml/`. When you register a project, it runs `docker compose config` to produce a fully-resolved YAML (with all env variables baked in) and stores it under a project name. After that, you can target the stack from any directory.

## Requirements

- Bash 4+
- Docker Engine with the `docker compose` plugin
- Linux or macOS

## Installation

```bash
# Clone anywhere
git clone https://github.com/oooiik/dc.git ~/.dc

# Make the main script executable and add to PATH
chmod +x ~/.dc/dc.bash
echo 'export PATH="$HOME/.dc:$PATH"' >> ~/.bashrc

# Optional: enable bash completion
echo 'source $HOME/.dc/dc_completion.bash' >> ~/.bashrc

# Reload
source ~/.bashrc
```

Symlink as `dc` if you prefer a shorter name:

```bash
ln -s ~/.dc/dc.bash ~/.dc/dc
```

## Usage

### Register a project

From inside a project folder containing a `docker-compose.yml`:

```bash
dc --new
# or short form
dc -n
```

You can also pass explicit paths:

```bash
dc --new ./docker-compose.prod.yml ./.env.prod my-api-prod
```

Arguments:
- `[compose-file]` — defaults to `$PWD/docker-compose.yml`
- `[env-file]` — defaults to `$PWD/.env` if it exists
- `[project-name]` — defaults to the name parsed from `docker compose config`

### List registered projects

```bash
dc --list
# or
dc -l
```

### Remove a project

```bash
dc --remove my-api
# or
dc -r my-api
```

### Run docker compose against a registered project

Anything after the project name is passed straight to `docker compose`:

```bash
dc my-api up -d
dc my-api ps
dc my-api logs -f web
dc my-api exec web bash
dc my-api restart redis
dc my-api down
```

## Bash completion

Once `dc_completion.bash` is sourced, you get:

- **Tab on project name** — completes against your registered project list
- **Tab after project name** — completes against `docker compose` subcommands and flags

## Why not just use aliases?

Aliases are static and tied to one path. `dc` lets you:

- Register stacks without writing a single line of shell config
- Keep working stacks even after moving or deleting the source folder (the resolved config is saved separately)
- Tab-complete project names without writing per-project aliases
- Switch contexts mid-task: `dc backend logs -f` from inside the frontend folder, no `cd` required

## Configuration

All state lives in `~/.config/dc/yml/` — one file per registered project, each one a fully-resolved Docker Compose YAML. Easy to inspect, easy to back up, easy to nuke.

## Contributing

Pull requests and issues are welcome. Keep changes minimal and POSIX-friendly where possible.

## License

[MIT](LICENSE) — Obidjon Toshev