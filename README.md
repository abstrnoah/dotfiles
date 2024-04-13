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
situation. This message will be removed once the design is actually implemented.

The flake is intended to produce packages that can be deployed via [nixphile].

Top-level packages are defined in `default.nix`, which contains the
following sections:
* Package bundles, such as per-machine package sets.
* Imports from [nixpkgs] and other inputs.
* Custom package definitions, usually wrapping or bundling imported packages.
  Some are constructed via package constructors of the following form.

```
<package> = config@{...}: package@{...}: <derivation>
```

Top-level packages are then `bundle`d together via [nixpkgs]'
`buildEnv`.

Reserved names:
* `config` - A set containing configuration data. In particular, values are
  _not_ derivations; instead, they are paths, strings, etc.
* `config.lib` - Utilities that I want to expose to clients of the flake via
  `this-repository.lib`.
* `packages` - A set containing packages, i.e. values are bona fide
  _derivations_. (The _only_ time `packages` is separated by system is at the
  top of the flake, where we delegate to [flake-utils].)

In general, attribute keys should use global names. That is, both package
constructors and the top-level flake should use the same namespace for `config`
and `packages` attribute keys. The `name` field of objects is generally ignored;
rather, things are addressed by attribute key.

In contrast to previous versions, we defer utilities to [nixpkgs]' library and
[flake-utils] as much as possible. In particular, we rely on [flake-utils] to
handle the per-system output riffraff. And we try to _always_ use [nixpkgs]'
library of builders (if at the expense of some boilerplate). An exception is the
function `bundle`, which current `buildEnv` but maybe should be written from
scratch for better robustness and stability under leaf changes.

```
bundle = "name": [<derivations>]: <derivation>
```

# TODO

* [ ] xclip? non-x-reliant clipboard manager?
* [ ] speedup, namely rewrite `bundle` and reduce core_env
* [ ] nixphile hooks
* [ ] refactor inputs follow nixpkgs
* [ ] more flake-zen way of loading nixpkgs with system and config than
      `import`?

---

[nixphile]: https://github.com/abstrnoah/nixphile
[nix-on-droid]: https://github.com/t184256/nix-on-droid
[nix-on-droid-readme-flake]: https://github.com/t184256/nix-on-droid#nix-flakes
[nixpkgs]: https://github.com/NixOS/nixpkgs/
[flake-utils]: https://github.com/numtide/flake-utils/
