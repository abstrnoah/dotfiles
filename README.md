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

# Nix flake design

Here we describe an intended new flake design to replace the currently messy
situation. This message will be removed once the design is actually implemented
(TODO).

The flake is intended to produce packages that can be deployed via [nixphile].

The flake produces the following outputs (see `flake.nix`):
* `config.${system}` - All configuration and utility functions. These are
  opinionated because they are specific to my dotfiles. Eventually I might
  factor out some utilities into a separate library. But for now this output
  should not be considered a usable library.
* `our-nixpkgs{,-unstable}.${system}` - Instances of `nixpkgs` with my custom
  configuration; see `config.${system}.cons-nixpkgs` for details.
* `packages.${system}` - The main package set. These are all my packages, many
  of them configured for my system with limited testing and probably unsuitable
  for anybody other than me. But who knows maybe you'll find a gem amid the
  muck. The set includes a number of "bundles" which are usually the things that
  actually get deployed; e.g. I have a `packages.${system}.coyote` which is
  deployed to my machine named `coyote`.
* `...` - The flake contains several additional fellows, but the ones above are
  the main characters.

The `packages` output is constructed in `default.nix` as the merger
```nix
upstreams // ours // bundles
```
The set `upstreams` collects every upstream dependency. If, for example, you
need to move an upstream package from `nixpkgs-unstable` to `nixpkgs`, then you
would do so in `upstreams`. Some are overridden within `ours`. Finally, within
`bundles`, packages are bundled into top-level environments via the function
`config.${system}.bundle`.

Note that every input passed to `default.nix` has been passed through the
function `choose-system` defined in `flake.nix` which, for the given `system`,
transforms a flake input `{ packages.${system} = <packages>; ... }` into `{
packages = <packages>; ... }`. Thus, `system` is already selected by the time we
get to `default.nix`.

In general, packages in `ours` are formed via constructors of the form
```
<package> = config@{...}: packages@{...}: <derivation>
```
where `config` and `packages` are inherited from the top level.


## ROADMAP

* [x] Begin overhaul `bundle`.
* [x] Overhaul `mk_src` packages.
* [x] Deal with nixphile hooks.
* [ ] Move any non-trivial packages into a constructor in a separate file.
* [ ] Streamline calling package constructors from within `default.nix`.
* [ ] Revisit `bundle` and other legacy library utils.

# TODO

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

---

[nixphile]: https://github.com/abstrnoah/nixphile
[nix-on-droid]: https://github.com/t184256/nix-on-droid
[nix-on-droid-readme-flake]: https://github.com/t184256/nix-on-droid#nix-flakes
[nixpkgs]: https://github.com/NixOS/nixpkgs/
[flake-utils]: https://github.com/numtide/flake-utils/
