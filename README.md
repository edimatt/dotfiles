# dotfiles

Personal HOME configuration

This repository contains my personal configuration files ("dotfiles") and scripts for setting up and customizing a Unix-like development environment.

## Features

- **Bash configuration**: `.bashrc` with useful aliases, functions, completions, and modular includes via `.bashrc.d/`
- **Editor and tool preferences**: Settings for editors and common CLI tools
- **Custom scripts**: Handy utilities and workflow enhancements
- **Modular structure**: Easy to extend and maintain via separate config files

## Usage

Clone this repository and symlink or copy the relevant files into your home directory. For example:

```sh
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
ln -s ~/dotfiles/bash/.bashrc ~/.bashrc
```

You can also use the `.bashrc.d/` directory to add machine- or project-specific scripts.

### Managing dotfiles with GNU Stow

You can use [GNU Stow](https://www.gnu.org/software/stow/) to manage your dotfiles with symlinks. This keeps your home directory clean and makes it easy to enable or disable groups of config files.

1. Install Stow (e.g. `brew install stow` on macOS).
2. Organize your dotfiles in subdirectories (e.g. `bash/`, `vim/`, etc.).
3. From the root of your dotfiles repo, run:

   ```sh
   stow bash
   ```

   This will symlink files from `bash/` into your home directory.

## License

These dotfiles are provided as-is for personal use and inspiration. Adapt them to fit your workflow!