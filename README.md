# `~analyticalnoa/.dotfiles`
![size](https://img.shields.io/github/repo-size/analyticalnoa/dotfiles?label=size)
![license](https://img.shields.io/github/license/analyticalnoa/dotfiles)
![updated](https://img.shields.io/github/last-commit/analyticalnoa/dotfiles/develop?label=rev)

A configuration stack used by analyticalnoa on Ubuntu.

- __Status__: Unstable, in development.
- __Platform__: Ubuntu 16.04 LTS, Linux 4.4.0-170-generic, x86_64-linux.

There are lots of [dotfiles](https://dotfiles.github.io) out there for
various platforms and preferences. At this early stage, I can only claim that
this one works on my platform, but the ultimate goal is for this configuration
to be portable to all the common Linux distros.

The *stack* is the set of packages configured by this repository.
The `packages` directory contains installation and configuration files for each
package in the stack and the `share` directory contains common files.

Most operations on the stack are done with `make` from the base of this
repository, with the following **usage**:

    make [ -C package/<pkg>] <operation>[-undo] [ VAR=<value> ... ]

where `<pkg>`-specific operations use the `-C` flag and global ones don't.

**TL;DR**, to **install** the complete stack, run

    make setup-anenv  # prompts to set various options.
    make all

and to **uninstall** the complete stack, run

    make all-undo


## the stack

Packages and their versions are put under their `<group>` name. All packages are
managed by nix unless otherwise mentioned (_preinstall_ means this repository
requires the package but provides no install script). Since nix ensures that
each package has access to the correct versions of its dependencies, versions
for dependencies sake is not so significant. However, some packages (eg tmux)
have disturbingly different configuration syntax between versions. Links point
to the packages' homepages.

### required

- [_**make**_](https://www.gnu.org/software/make) _4.1_ - (preinstall) maker.
- [_**bash**_](https://www.gnu.org/software/bash/) _4.3_ - (preinstall)
  although zsh will be the default shell, bash is used for setup.
- [_**nix**_](https://nixos.org/) _2.3.1_ in multi-user mode - package manager.
- [_**git**_](https://git-scm.com) _2.24_ - version control.

### core

- [_**zsh**_](https://www.zsh.org/) _5.1.1_ - shell.
- [_**i3wm**_](https://i3wm.org/) _4.11_ - windows manager.
- [_**tmux**_](http://tmux.github.io/) _2.1_,
  with [_**tmuxinator**_](https://github.com/tmuxinator/tmuxinator) _0.7.0_ -
  terminal multiplexer.
- [_**ranger**_](https://ranger.github.io/) _1.7.1_ - file manager.
- [_**vim**_](https://www.vim.org/) _7.4_, with some plugins - text editor.
- [_**xclip**_](https://launchpad.net/xclip) _0.12_ - clipboard tool.
- [_**htop**_](https://hisham.hm/htop/) _2.0.1_ - system monitor.

### optional

- [_**visidata**_](http://visidata.org/) _1.5.2_ - tabular data editor.
- [_**firefox**_](https://www.mozilla.org/firefox/) _71.0_ - browser.
- [_**xbacklight**_](https://github.com/tcatm/xbacklight) _1.2.1_ - screen
  brightness tool.
- [_**thefuck**_](https://github.com/nvbn/thefuck) _3.2_ - shell autocorrecter.


## controlling the stack

There are _install operations_ and _setup operations_, and their inverses. The
former installs packages on the machine (most via `nix-env`), while the latter
installs their configuration via symlinks. Setup operations can be preformed
independent of install operations, so if you have trouble installing a
particular package and need to do it manually, you can still use this repository
to handle configuration.

Your environment needs to be setup first. Run

    make set-anenv

to be prompted for the values of various `$ANENV_` variables. Defaults will be
read from and entries will be written to `$ANENV_DOTFILES/anenv`.

To install or setup a `<pkg>`, run

    make -C package/<pkg> ( install | setup )

and to install or setup a `<group>` of packages, run

    make ( install-<group> | setup-<group> )

_Peripheral operations_ are non-package or non-group operations and are listed
below.


    make setup-anenv

> Setup the `$ANENV_` environment variables by prompt or via `VAR=<value>`
pairs. If it exists, `$ANENV_DOTFILES/anenv` is sourced and variables that are
set are provided as defaults. You can change these or leave them be. The final
environment is written to `$ANENV_DOTFILES/anenv`. If `$ANENV_DOTFILES` is
empty, the current directory is taken as default.

    make setup-wallpaper [ ANENV_WALLPAPER=share/<wallpaper> ]
                         [ ANENV_WALLPAPER_LOCK=share/<wallpaperlock> ]

> Link `<wallpaper>` to `$ANENV_HOME/.wallpaper` and `<wallpaperlock>` to
`$ANENV_HOME/.wallpaperlock`. If left empty, `share/wallpaper-home.png` is the
default wallpaper and `share/wallpaper-lock.png` is the default lock screen.
