# `~abstrnoah/.dotfiles`

My dotfiles use [nixphile] (also by me) for most deployment. Setup goes
something like the following. Throughout, `PACKAGE` refers to the flake package
to deploy, probably the new machine's hostname.

```sh
# Bootstrap Nix.
sh <(curl -L https://raw.githubusercontent.com/abstrnoah/nixphile/main/nixphile)

# Somewhat hacky solutions to outstanding deployment issues.
# Among other things, clone dotfiles to ~/.dotfiles.
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

See the [nix-on-droid] README about [installing via
flake][nix-on-droid-readme-flake].

Install the app.

In the nix-on-droid terminal:

```sh
# Bootstrap nix-on-droid environment.
nix-on-droid switch --flake 'github:abstrnoah/dotfiles'

# Deploy the rest via nixphile.
nix run 'github:abstrnoah/nixphile' 'github:abstrnoah/dotfiles#android'

# Continue as above, starting from ssh-keygen...
```

---

[nixphile]: https://github.com/abstrnoah/nixphile
[nix-on-droid]: https://github.com/t184256/nix-on-droid
[nix-on-droid-readme-flake]: https://github.com/t184256/nix-on-droid#nix-flakes
