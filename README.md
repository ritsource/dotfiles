# Configurations

A dotfiles and configuration management system that helps you sync your shell scripts and dotfiles across different machines using git.

## Overview

This repository provides a set of tools to:

- **Install** your dotfiles and scripts to your home directory
- **Backup** your current dotfiles and scripts back to the repository
- **Sync** configurations across different machines
- **Manage** custom shell scripts in a centralized location

## Project Structure

```
.
├── src/                    # Source scripts (with .sh extension) - tracked in git
│   ├── install-scripts.sh
│   ├── backup-scripts.sh
│   ├── install-dotfiles.sh
│   └── backup-dotfiles.sh
├── scripts/                # Your custom shell scripts - tracked in git
│   ├── confedit.sh
│   └── lolprint.sh
├── dotfiles/               # Your dotfiles (with nested structure) - tracked in git
│   ├── .zshrc
│   ├── .tmux.conf
│   └── .config/
│       ├── nvim/
│       └── alacritty/
├── config.yml              # Configuration file - tracked in git
└── build.sh                # Build script - tracked in git
```

## Quick Start

### Step 1: Build the Scripts

```bash
./build.sh
```

This will:

- Create the `bin/` directory if it doesn't exist
- Copy all `.sh` files from `src/` to `bin/`
- Remove the `.sh` extension (e.g., `install-scripts.sh` -> `install-scripts`)
- Make them executable

**After building, you'll have these executables in `bin/`:**

- `bin/install-scripts`
- `bin/backup-scripts`
- `bin/install-dotfiles`
- `bin/backup-dotfiles`

### Step 2: Install Your Dotfiles

Install all dotfiles defined in `config.yml` to your home directory:

```bash
./bin/install-dotfiles
```

This will:

- Read dotfile paths from `config.yml`
- Copy files from `dotfiles/` to `$HOME/`
- Create necessary directories
- Backup existing files before overwriting

### Step 3: Install Your Scripts

Install custom scripts to `$HOME/.custom/scripts/bin`:

```bash
./bin/install-scripts
```

This will:

- Copy all `.sh` files from `scripts/` to `$HOME/.custom/scripts/bin`
- Remove the `.sh` extension
- Make them executable

## Usage

### Scripts

#### `install-scripts`

Installs shell scripts from the `scripts/` directory to `$HOME/.custom/scripts/bin`.

```bash
./bin/install-scripts
```

**What it does:**

- Finds all `.sh` files in `scripts/`
- Copies them to `$HOME/.custom/scripts/bin` (without `.sh` extension)
- Makes them executable
- Shows which files were installed

#### `backup-scripts`

Backs up scripts from `$HOME/.custom/scripts/bin` to the `scripts/` directory.

```bash
./bin/backup-scripts
```

**What it does:**

- Reads all executable files from `$HOME/.custom/scripts/bin`
- Copies them back to `scripts/` (adding `.sh` extension)
- Compares files to detect changes
- Shows which files were updated

#### `install-dotfiles`

Installs dotfiles from `dotfiles/` to your home directory based on `config.yml`.

```bash
./bin/install-dotfiles
```

**What it does:**

- Parses dotfile paths from `config.yml`
- Copies files from `dotfiles/` to `$HOME/`
- Maintains nested directory structure (e.g., `.config/nvim/init.vim`)
- Creates necessary directories
- Backs up existing files before overwriting

#### `backup-dotfiles`

Backs up dotfiles from your home directory to `dotfiles/` based on `config.yml`.

```bash
./bin/backup-dotfiles
```

**What it does:**

- Reads dotfile paths from `config.yml`
- Copies current files from `$HOME/` to `dotfiles/`
- Maintains nested directory structure
- Compares files to detect changes
- Shows which files were updated

## Configuration

### `config.yml`

The `config.yml` file defines which dotfiles to manage:

```yaml
dotfiles:
  - .zshrc
  - .bashrc
  - .bash_profile
  - .profile
  - .tmux.conf
  - .config/nvim/init.vim
  - .config/nvim/coc-settings.json
  - .config/nvim/extra.vim
  - .config/alacritty/alacritty.yml
uname: Darwin
```

**Fields:**

- `dotfiles`: List of dotfile paths relative to `$HOME`
- `uname`: Expected operating system (e.g., `Darwin`, `Linux`)

The scripts will warn you if the `uname` in `config.yml` doesn't match your system's `uname -s`.

### Dotfiles Directory Structure

The `dotfiles/` directory mirrors the structure of your home directory. For example:

- `dotfiles/.zshrc` \_> `$HOME/.zshrc`
- `dotfiles/.config/nvim/init.vim` -> `$HOME/.config/nvim/init.vim`

## Workflow Examples

### Setting Up a New Machine

1. Clone this repository
2. **Build the scripts first** (required!): `./build.sh`
   - This creates the `bin/` directory with executable scripts
3. Install dotfiles: `./bin/install-dotfiles`
4. Install scripts: `./bin/install-scripts`

### Updating Dotfiles

1. Make changes to your dotfiles in `$HOME/`
2. Backup changes: `./bin/backup-dotfiles`
3. Commit and push changes

### Adding a New Dotfile

1. Add the path to `config.yml`:
   ```yaml
   dotfiles:
     - .newfile
   ```
2. Copy the file to `dotfiles/`:
   ```bash
   cp ~/.newfile dotfiles/.newfile
   ```
3. Commit the changes

### Updating Scripts

1. Edit scripts in `scripts/`
2. Install them: `./bin/install-scripts`
3. Or edit them directly in `$HOME/.custom/scripts/bin/`
4. Backup changes: `./bin/backup-scripts`
5. Commit the changes

### Updating Source Scripts (in `src/`)

If you modify scripts in `src/`, you need to rebuild:

1. Edit scripts in `src/` (e.g., `src/install-dotfiles.sh`)
2. Rebuild: `./build.sh`
3. The updated executables will be in `bin/`

## Requirements

- **Git**: Required for finding the project root
- **Bash**: All scripts are written in bash
- **lolcat** (optional): For rainbow-colored output

## Notes

- **The `bin/` directory is not tracked in git** - you must run `./build.sh` after cloning to generate the executables
- Scripts in `bin/` are executable files without extensions (generated from `src/`)
- Scripts in `scripts/` have `.sh` extensions
- The `build.sh` script removes the `.sh` extension when copying to `bin/`
- All scripts must be run from within the git repository
- If you update scripts in `src/`, rebuild with `./build.sh` to update `bin/`

## Platform Support

**⚠️ Testing Status:**

These configurations have been tested and are actively used on **macOS**. They have **not been tested recently on Linux**, though the scripts should work on Linux systems as well.

If you encounter any issues on Linux or other platforms, or if you'd like to contribute improvements for cross-platform compatibility, please feel free to:

- Open an issue describing the problem
- Submit a pull request with fixes or improvements
- Share your testing results

Contributions are welcome! 🎉

## Credit

This project is originally inspired by [adotg/.dotfiles](https://github.com/adotg/.dotfiles).
