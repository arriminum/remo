# Remo Usage Guide

Remo is a small and defensive command-line tool for safely removing directory contents during build and deploy tasks.

It was created for situations where you often need to clean folders such as `dist`, `deploy`, `build`, or a specific website directory inside `/var/www`.

Remo is maintained by [Arriminum](https://arriminum.com).

The main goal is simple:

> Make common cleanup tasks easy, but make dangerous deletions hard.

---

## What Remo Does

By default, Remo removes the contents of a directory, but keeps the directory itself.

For example:

```bash
remo deploy
```

This removes everything inside `deploy`, but the `deploy` directory remains.

This behavior is safer for build and deploy scripts because many workflows expect the base directory to continue existing after cleanup.

---

## Basic Usage

```bash
remo <directory>
```

Example:

```bash
remo ../deploy
```

This removes all files and folders inside `../deploy`.

---

## Remove Directory Contents

This is the default behavior:

```bash
remo --contents <directory>
```

Example:

```bash
remo --contents /var/www/my-site
```

This keeps `/var/www/my-site`, but removes everything inside it.

The same result can be achieved with:

```bash
remo /var/www/my-site
```

---

## Remove the Directory Itself

To remove the directory itself, use:

```bash
remo --dir <directory>
```

Example:

```bash
remo --dir deploy/libs
```

This removes the `deploy/libs` directory completely.

Because this action is more dangerous, Remo asks for confirmation unless you use `--yes`.

```bash
remo --dir --yes deploy/libs
```

---

## Remove and Recreate a Directory

To remove a directory and create it again:

```bash
remo --recreate <directory>
```

Example:

```bash
remo --recreate deploy
```

This removes `deploy` and then creates a new empty `deploy` directory.

For scripts, use:

```bash
remo --recreate --yes deploy
```

---

## Dry Run

Use `--dry-run` to see what Remo would delete without removing anything:

```bash
remo --dry-run deploy
```

For directory removal:

```bash
remo --dry-run --dir deploy/libs
```

For recreate mode:

```bash
remo --dry-run --recreate deploy
```

Dry run still runs the safety checks. If a path is protected, Remo refuses it even in dry-run mode.

---

## Confirmation

Remo asks for confirmation when using:

```text
--dir
--recreate
```

To skip confirmation in scripts, use:

```bash
--yes
```

Example:

```bash
remo --recreate --yes dist
```

The default `--contents` mode does not ask for confirmation.

---

## Protected Paths

Remo refuses to operate on important Linux paths such as:

```text
/
/bin
/boot
/dev
/etc
/home
/lib
/lib64
/media
/mnt
/opt
/proc
/root
/run
/sbin
/srv
/sys
/tmp
/usr
/var
/var/www
```

It also refuses common user-level paths such as:

```text
$HOME
$HOME/src
$HOME/lib
$HOME/Downloads
$HOME/Documents
$HOME/Desktop
$HOME/Projects
$HOME/projetos
```

These paths are blocked to reduce the risk of deleting a system directory, a whole user folder, or an important project root by mistake.

---

## Shallow Path Protection

Remo refuses shallow paths because they are often too broad.

For example, paths like these are considered risky:

```text
/home/user
/home/user/src
/var/www
```

More specific paths are allowed if they pass all safety checks:

```text
/home/user/src/my-project/dist
/var/www/my-site
```

This helps prevent accidents caused by missing variables or incomplete paths.

---

## Symlink Protection

Remo refuses to operate directly on symlinks.

For example, if `deploy` is a symlink, this command will be refused:

```bash
remo deploy
```

This prevents a safe-looking path from pointing to a dangerous location.

---

## Examples for Build Scripts

Clean a distribution folder:

```bash
remo --recreate --yes dist
```

Clean a deploy folder:

```bash
remo --contents deploy
```

Clean a website directory before copying new files:

```bash
remo --contents --yes /var/www/my-site
```

Check what would be removed before running a deploy:

```bash
remo --dry-run /var/www/my-site
```

Remove a generated dependency folder:

```bash
remo --dir --yes deploy/libs
```

---

## Installation

After building the script, install it with:

```bash
sudo install -m 755 dist/remo /usr/local/bin/remo
```

Then check:

```bash
remo --version
remo --help
```

To remove it:

```bash
sudo rm /usr/local/bin/remo
```

---

## Development Checks

Recommended checks during development:

```bash
bash -n src/remo
shellcheck src/remo
shfmt -i 4 -w src/remo
```

Suggested Makefile targets:

```bash
make check
make lint
make format
make test
make build
```

---

## Design Principle

Remo is intentionally conservative.

It is not meant to replace `rm`.

It is meant to make repeated cleanup tasks safer in build and deploy workflows.

When in doubt, Remo should refuse the operation.
