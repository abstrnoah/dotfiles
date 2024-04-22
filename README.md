# `~abstrnoah/.dotfiles`

My dotfiles use [nixphile] (also by me) for most deployment. Setup goes
something like the following. Throughout, `PACKAGE` refers to the flake package
to deploy, probably the new machine's hostname.

```sh
# Bootstrap Nix.
sh <(curl -L https://raw.githubusercontent.com/abstrnoah/nixphile/main/nixphile)

# Somewhat hacky solutions to outstanding deployment issues.
# Among other things, clone dotfiles to ~/.dotfiles if not already present.
# Note that if ~/.dotfiles is already cloned, then we may need to manually pull.
nix run 'github:abstrnoah/dotfiles#PACKAGE.nixphile_hook_pre'

# Deploy the environment.
nix run 'github:abstrnoah/nixphile' 'github:abstrnoah/dotfiles#PACKAGE'

# Set login shell (requires `sudo` because nix's zsh is not in /etc/shells).
# (If no root privileges, then probably use nix-portable for everything anyway.)
sudo chsh -s $(which zsh) abstrnoah

# Create an ssh key, transfer public key to personal server via pastebin.
ssh-keygen
cat ~/.ssh/id_rsa.pub | pastebin -

# Configure ssh from template.
cp ~/.dotfiles/share/ssh_config_template ~/.ssh/config
vim ~/.ssh/config

# Secret stuff.
# ...
```

# nix-on-droid

See the [nix-on-droid] README about [installing as
flake][nix-on-droid-readme-flake].

Install the app.

In the nix-on-droid terminal, do

```sh
# Bootstrap nix-on-droid environment.
nix-on-droid switch --flake 'github:abstrnoah/dotfiles#default'
```

and then continue as above from the `nixphile_hook_pre` step, with
`PACKAGE=nix-on-droid`.

# minimal nixless

TODO I think I got rid of this bad boy.

To deploy a minimal set of dotfiles that doesn't depend on Nix (other than
nix-portable for deployment), do

```sh
# Fetch nix-portable.
NIXPHILE_MODE=portable sh <(curl -L https://raw.githubusercontent.com/abstrnoah/nixphile/main/nixphile)

# Deploy minimal dotfiles.
~/.nixphile/bin/nix-portable nix run 'github:abstrnoah/dotfiles#minimal_nixless'
```

Note that this feature is really poorly implemented for now until I have more
time.

# Nix flake structure

The flake's "installables" (see nix(1)) are intended to produce packages that
can be deployed via [nixphile].

The flake produces the following outputs:
* `upstreams.${system}` - All upstream packages used by other parts of the
  flake.
* `ours.${system}` - Where upstreams are overridden. Many of these are the
  result of bundling upstreams with my own configuration. They have only been
  tested insofar as they run on my specific machine, so probably unsuitable for
  other folks. But who knows maybe you'll find a gem amid the muck.
* `bundles.${system}` - Bundles of packages from the above two outputs. This is
  where I organise the above packages into useful collections. For instance,
  there is a `coyote` bundle that is deployed to the so-named machine.
* `packages.${system}` - The main package set, obtained by merging `upstreams //
  ours // bundles`.
* `lib.any` - A library of utilities that do not depend on `system`. Many of
  these come from `nixpkgs.lib`.
* `lib.${system}` - A library of utilities that do depend on `system`, many of
  which are build helpers coming from or wrapping around `nixpkgs` utilities. We
  also merge the contents of `lib.any` into every `lib.${system}`. Note that
  `lib` is using an instance of `nixpkgs` configured by
  `config.any.nixpkgs-args`.
* `config.any,config.${system}` - My own configuration parameters.
* `...` - There are other fellows, but the above are the main characters.

All of our (downstream) packages are constructed by functions of the form
```
package = lib@{...}: config@{...}: packages@{...}: <derivation>
```
These are called by `lib.${system}.cons-package` which
passes in the necessary arguments and allows for overriding (a very simple
version of [nixpkgs]' `callPackage`).

## ROADMAP

* [x] Begin overhaul `bundle`.
* [x] Overhaul `mk_src` packages.
* [x] Deal with nixphile hooks.
* [x] Move any non-trivial packages into a constructor in a separate file.
* [x] Streamline calling package constructors from within `default.nix`.
* [x] Revisit `bundle` and other legacy library utils.
* [ ] Revisit flake organisation
    * [ ] Deal with `lib` versus `config`
    * [ ] Consider bringing `upstreams` etc into flake top-level
* [ ] Finally write syncthing systemd unit
* [ ] Clean up bundles
* [ ] Revise README
* [ ] `default.nix` -> `packages.nix`

# TODO

* [ ] Rewrite nixphile
* [ ] xclip? non-x-reliant clipboard manager?
* [ ] speedup, namely rewrite `bundle` and reduce core_env
* [ ] refactor inputs follow nixpkgs
* [ ] more flake-zen way of loading nixpkgs with system and config than
  `import`?
* [ ] names replace `_` with `-`
* [ ] bundle together all my common inputs like `flake-utils` and commonly-used
  system-agnostic `nixpkgs` utilities into a separate flake.
* [ ] make deploy to non-nix system actually work
* [ ] Once nixphile supports both ln and cp trees, the cp trees can replace most
  (all?) before-deploy hooks.
* [ ] Deal with environment riffraff with zsh i3 etc
* [ ] nix-ify i3wm so that execs there can refer to nix paths

---

[nixphile]: https://github.com/abstrnoah/nixphile
[nix-on-droid]: https://github.com/t184256/nix-on-droid
[nix-on-droid-readme-flake]: https://github.com/t184256/nix-on-droid#nix-flakes
[nixpkgs]: https://github.com/NixOS/nixpkgs/
[flake-utils]: https://github.com/numtide/flake-utils/
