# Remo

Remo is a small and defensive command-line tool for safely removing directory contents during build and deploy tasks.

It was created to make common cleanup tasks easy, while making dangerous deletions hard.

Remo is maintained by [Arriminum](https://arriminum.com).

---

## What It Does

By default, Remo removes the contents of a directory, but keeps the directory itself.

```bash
remo deploy
```

This removes everything inside `deploy`, but keeps the `deploy` directory.

For more usage examples, see [docs/usage.md](docs/usage.md).

---

## Why Remo Exists

Build and deploy scripts often need commands like:

```bash
rm -rf dist/*
rm -rf deploy/*
rm -rf /var/www/my-site/*
```

These commands work, but they can become risky when a variable is empty, a path is wrong, or a script runs from an unexpected directory.

Remo adds safety checks before deleting anything.

---

## Features

- Removes directory contents by default
- Supports `--dir`, `--recreate`, `--dry-run` and `--yes`
- Blocks important Linux system paths
- Blocks common user folders
- Refuses symlinks
- Resolves the real absolute path before deleting
- Refuses shallow paths

---

## Installation

Build the script:

```bash
make build
```

Install it globally:

```bash
sudo make install
```

By default, this installs Remo to:

```text
/usr/local/bin/remo
```

Check the installation:

```bash
remo --version
remo --help
```

---

## Basic Usage

Clean a directory, keeping the directory itself:

```bash
remo deploy
```

Preview what would be deleted:

```bash
remo --dry-run deploy
```

Remove and recreate a directory:

```bash
remo --recreate --yes dist
```

Remove a directory completely:

```bash
remo --dir --yes deploy/libs
```

Full usage guide:

```text
docs/usage.md
```

---

## Development

Recommended checks:

```bash
bash -n src/remo
shellcheck src/remo
shfmt -i 4 -w src/remo
```

With Makefile:

```bash
make check
make lint
make format
make test
make build
```

---

## Requirements

Runtime:

- Bash
- realpath
- find

Development:

- ShellCheck
- shfmt
- make

On Ubuntu:

```bash
sudo apt install shellcheck shfmt make
```

---

## License

MIT License.

Copyright (c) 2026 [Arriminum](https://arriminum.com).

See [LICENSE](LICENSE).

---

## Design Principle

Remo is intentionally conservative.

It is not a replacement for `rm`.

It is a safer helper for repeated cleanup tasks in build and deploy workflows.

When in doubt, Remo should refuse the operation.
