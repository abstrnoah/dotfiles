# abstrnoah/dotfiles

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

# Create an ssh key, transfer public key to personal server via pastebin.
ssh-keygen
cat ~/.ssh/id_rsa.pub | pastebin -

# Configure ssh from template.
cp ~/.dotfiles/share/ssh_config_template ~/.ssh/config
vim ~/.ssh/config

# Secret stuff.
# ...
```

---

[nixphile]: https://github.com/abstrnoah/nixphile
