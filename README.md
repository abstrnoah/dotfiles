# `~abstrnoah/.dotfiles`

My dotfiles use [nixphile] for most deployment. Setup goes
something like the following. Throughout, `PACKAGE` refers to the flake package
to deploy, probably the new machine's hostname.

```sh
# Bootstrap Nix.
sh <(curl -L https://raw.githubusercontent.com/abstrnoah/nixphile/main/nixphile)

# Clone dotfiles locally to "~/.dotfiles".
# If ~/.dotfiles is already cloned, then you should manually pull.
nix run 'github:abstrnoah/dotfiles#clone-dotfiles'

# Deploy the environment.
nix run 'github:abstrnoah/dotfiles#nixphile' 'github:abstrnoah/dotfiles#PACKAGE'

# Setup login shell.
export SHELL=$(nix eval --raw 'github:abstrnoah/dotfiles#config.SYSTEM.shell')
sudo cp ~/.nixphile/env/etc/shells /etc/shells
sudo chsh -s $SHELL abstrnoah

# Install root systemd units.
# (TODO)

# Reload systemd user daemon.
systemctl --user daemon-reload

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

As above with `PACKAGE=nix-on-droid`, except replace the first step with
```sh
# Bootstrap nix-on-droid environment.
nix-on-droid switch --flake 'github:abstrnoah/dotfiles#default'
```

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
  where I organise them into useful collections. For instance,
  there is a `coyote` bundle that is deployed to the so-named machine.
* `packages.${system}` - The main package set, obtained by merging `upstreams //
  ours // bundles`.
* `config.${system}` - My own utilities and configuration parameters. Note that
  I collect "library" functions in this output, instead of separating them into
  a separate `out` output. That's because this flake really shouldn't be used as
  an upstream library; everything should be viewed as "the author's custom
  configuration".
* `...` - There might be others, but the above are the main characters.

All of our (downstream) packages are constructed by functions of the form
```
package = config@{...}: packages@{...}: <derivation>
```
These are called by `config.${system}.cons-package` which passes in the
necessary arguments and allows for overriding (a very simple version of
[nixpkgs]' `callPackage`).

P.S. If you don't like how the code is formatted, then blame [nixfmt].

# TODO


* [ ] rewrite nixphile
* [ ] xclip? non-x-reliant clipboard manager?
* [ ] speedup, namely `bundle`
* [ ] inputs follow nixpkgs
* [ ] separate utils into separate lib flake?
* [ ] make deploy to non-nix system actually work
* [ ] Deal with environment riffraff with zsh i3 etc
* [ ] nix-ify i3wm so that execs there can refer to nix paths
* [ ] deal with root config like system systemd units
* [ ] actually test deployment on completely fresh machine
* [ ] `QT_XCB_GL_INTEGRATION=none`
* [ ] migrate back to bash
* [ ] fix `oops()` functions
* [ ] add metadata to deployment for easy introspection

## nixpkgs update to 24.11
* [ ] nixfmt name change
* [ ] `substitutions` instead of `replacements`
* [ ] qutebrowser runtime darkmode toggle

## neovim migration
* [ ] see [1] re `notermguicolors`
* [ ] colorscheme
    * [ ] vim highlighting not as good as before
    * [ ] maybe do away with solarized
    * [ ] treesitter
* [ ] gvim
* [ ] completions

---

[nixphile]: https://github.com/abstrnoah/nixphile
[nix-on-droid]: https://github.com/t184256/nix-on-droid
[nix-on-droid-readme-flake]: https://github.com/t184256/nix-on-droid#nix-flakes
[nixpkgs]: https://github.com/NixOS/nixpkgs/
[flake-utils]: https://github.com/numtide/flake-utils/
[nixfmt]: https://github.com/NixOS/nixfmt
[1]: https://stackoverflow.com/questions/78521945/neovim-0-10-colorscheme-changes-affecting-highlighting-in-terminal
