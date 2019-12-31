# [`~analyticalnoa/.dotfiles`](https://github.com/analyticalnoa/dotfiles)
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
The `./packages` directory contains installation and configuration files for each
package in the stack and the `./share` directory contains common files.

You can put this repository anywhere, but should leave it there, as symlinks
will be made to its contents.

**Usage**:

    make <command>[-<spec>][-undo] [ VAR=<value> ... ]

where `<spec>` is a package, group, or other (see below) name. The `-undo`
suffix means preform the inverse command. Environment variables specified on the
shell override the current environment overrides those in `./anenv` override
defaults.

**TL;DR**, to **install** the complete stack, run

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

    make all

> Equivelant to running `make setup-anenv install setup`.

    make setup-anenv

> Open `./anenv` in `$EDITOR`, which will contain a list of variables. You
> should set these as desired and then save/quit. The variables will exported to
> the environment. Then `./anenv` will be linked from `$HOME/.anenv`. (Currently
> variables specified on the command line will be ignored for this operation.)

    make install

> Install all packages.

    make setup

> Setup all packages.

    make install-<spec>

> Install `<spec>`, which can be a package or group, on the machine.

    make setup-<spec>

> Setup the configuration of `<spec>`, which can be a package or group, with
> symlinks from these dotfiles.

    make setup-wallpaper [ ANENV_WALLPAPER=./share/<wallpaper> ]
                         [ ANENV_WALLPAPER_LOCK=./share/<wallpaperlock> ]

> Link `$ANENV_WALLPAPER` to `$HOME/.wallpaper` and `$ANENV_WALLPAPER_LOCK` to
> `$HOME/.wallpaperlock`. (Defaults are `./share/wallpaper-home.png` and
> `./share/wallpaper-lock.png` resp.)
