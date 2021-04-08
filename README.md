# [`~abstractednoah/.dotfiles`](https://github.com/abstractednoah/dotfiles)
![size](https://img.shields.io/github/repo-size/abstractednoah/dotfiles?label=size)
![license](https://img.shields.io/github/license/abstractednoah/dotfiles)
![updated](https://img.shields.io/github/last-commit/abstractednoah/dotfiles/develop?label=rev)

A configuration stack used by abstractednoah on Ubuntu.

__Platform__: Ubuntu 16.04 LTS, Linux 4.4.0-170-generic, x86\_64-linux.

*This README is under development.*

## Installation

These dotfiles rely on the Nix package manager, however as of this writing some
packages just need to be natively installed onto Ubuntu. Or they're needed to
install Nix in the first place. Here are the crucial packages that you need to
install without Nix, either with `apt-get` or your distribution's native package
manager:
- curl
- git
- __TODO__ ...

Clone this repository into `~/.dotfiles`:

    git clone https://github.com/abstractednoah/dotfiles ~/.dotfiles

Install Nix. You should the
[Nix installation manual](https://nixos.org/manual/nix/stable/#sect-multi-user-installation)
for the latest instructions, but as of this writing installing Nix was as simple
as running

    sh <(curl -L https://nixos.org/nix/install) --daemon

Log out and in again so that Nix can populate your environment. Symlink our Nix
config to `~/.config` like so

    ln -s ~/.dotfiles/package/nix/config.nix ~/.config/nixpkgs/config.nix

Finally we can have Nix install the `desktopPackages` override that is declared
in `config.nix`. You can either set `nix-env` up to use the latest nixpkgs
channel, or install using
[abstractednoah/nixpkgs](https://github.com/abstractednoah/nixpkgs)
by running

    nix-env \
        --file \
            https://github.com/abstractednoah/nixpkgs/archive/an-master.tar.gz \
        --install --remove-all --attr desktopPackages

with an optional `--verbose` flag if you want to see what's happening (the
initial run will take quite a long while).

__TODO__: Document various post-Nix-install tasks that would be required on a
fresh install, in particular symlinking various `package/<package>` directories
to home.


Finally, some optional packages that we've not gotten working with Nix and that
will need to be installed another way:
- zoom
