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

Finally we can have Nix install the `clientPackages` override that is declared
in `config.nix`. You can either set `nix-env` up to use the latest nixpkgs
channel, or install using
[abstractednoah/nixpkgs](https://github.com/abstractednoah/nixpkgs)
by running

    nix-env \
        --file \
            https://github.com/abstractednoah/nixpkgs/archive/an-master.tar.gz \
        --install --remove-all --attr clientPackages

with an optional `--verbose` flag if you want to see what's happening (the
initial run will take quite a long while).

__TODO__: Document various post-Nix-install tasks that would be required on a
fresh install, in particular symlinking various `package/<package>` directories
to home.

## Optionals

Some optional packages can't be installed via Nix at this time (either they're
buggy on Ubuntu, or they haven't been added to nixpkgs yet).

### i3-gaps
Note that if you use i3 with these dotfiles, you need the
[i3-gaps fork](https://github.com/Airblader/i3)
because our `i3/config` has options only supported by i3-gaps.

Until we migrate to NixOS, desktop environments need to be installed with a
native package manager, because Nix's encapsulation just leads to too many
problems on non-NixOS systems. i3-gaps can be installed via `apt-get` after
adding a PPA. See Airblader's
[install wiki](https://github.com/Airblader/i3/wiki/installation)
for a list of current PPAs. After `apt-get update`ing, install i3-gaps by
running something like `apt-get install i3-wm` (note that the name is *not*
`i3-gaps` or similar); view the package list of the PPA to get the exact name.
Log in and out again, and you should have i3-gaps.


### zoom
Zoom via Nix doesn't seem to work (cause unknown, haven't had time to look into
it). But it should be available via your native package manager.

### Wacom tablets
Wacom libraries are shipped with Ubuntu 16.04 by default, but for some tablets
you need to build `input-wacom` from source. No-hassle instructions are provided
here:
<https://github.com/linuxwacom/input-wacom/wiki/Installing-input-wacom-from-source>.
If for some reason your tablet stops working again (this has happened a few
times for me, and I still don't know why), run

    sudo rmmod wacom
    sudo modprobe wacom

or

    sudo rmmod wacom_w8001
    sudo modprobe wacom_w8001

(`rmmod` will tell you if `wacom` or `wacom_w8001` is not found).
