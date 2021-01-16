# [`~abstractednoah/.dotfiles`](https://github.com/abstractednoah/dotfiles)
![size](https://img.shields.io/github/repo-size/abstractednoah/dotfiles?label=size)
![license](https://img.shields.io/github/license/abstractednoah/dotfiles)
![updated](https://img.shields.io/github/last-commit/abstractednoah/dotfiles/develop?label=rev)

A configuration stack used by abstractednoah on Ubuntu.

- __Status__: Unstable, in development.
- __Platform__: Ubuntu 16.04 LTS, Linux 4.4.0-170-generic, x86\_64-linux.

__Note__ that at this time this README is only guaranteed to be up to date with
some commit inclusively between the `master` and `develop` branches, and as a
result is probably not super accurate.

## Installation

Symlink this directory to `~/.dotfiles`. Then symlink `package/<package>` or
their contents to the relevant place.

## The package stack

Packages and their versions are put under their `<group>` name. All packages are
managed by nix unless otherwise mentioned (_preinstall_ means this repository
requires the package but provides no install script; _manual_ means that install
script for the package haven't been written). Since nix ensures that
each package has access to the correct versions of its dependencies, versions
for dependencies sake is not so significant. However, some packages (eg tmux)
have disturbingly different configuration syntax between versions. Links point
to the packages' homepages.

### required

- [_**make**_](https://www.gnu.org/software/make) _4.1_ - (preinstall) maker.
- [_**bash**_](https://www.gnu.org/software/bash/) _4.3_ - (preinstall)
  although zsh will be the default shell, bash is used for setup.
- [_**nix**_](https://nixos.org/) _2.3.1_ (manual) in multi-user mode - package
  manager.
- [_**git**_](https://git-scm.com) _2.24_ - version control.

### core

- [_**zsh**_](https://www.zsh.org/) _5.1.1_ - shell.
- [_**i3wm**_](https://i3wm.org/) _4.11_ - (manual) windows manager.
- [_**tmux**_](http://tmux.github.io/) _2.1_,
  with [_**tmuxinator**_](https://github.com/tmuxinator/tmuxinator) _1.1_ -
  terminal multiplexer.
- [_**ranger**_](https://ranger.github.io/) _1.7.1_ - (manual) file manager.
- [_**vim**_](https://www.vim.org/) _7.4_, with some plugins - text editor.
- [_**xclip**_](https://launchpad.net/xclip) _0.12_ - (manual) clipboard tool.
- [_**htop**_](https://hisham.hm/htop/) _2.0.1_ - system monitor.

### optional

- [_**visidata**_](http://visidata.org/) _1.5.2_ - tabular data editor.
- [_**firefox**_](https://www.mozilla.org/firefox/) _71.0_ - (manual) browser.
- [_**xbacklight**_](https://github.com/tcatm/xbacklight) _1.2.1_ - (manual)
  screen brightness tool.
- [_**thefuck**_](https://github.com/nvbn/thefuck) _3.2_ - (manual) shell
  autocorrecter.
- [_**gnome-terminal**_]() _3.18.3_ - (manual) any terminal will do, but these
  dotfiles have a dark and light theme for GNOME's.
