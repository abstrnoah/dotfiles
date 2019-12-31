include header.mk
.PHONY = missing_command help all


# ------------------------------------------------------------------------------
missing_command: help
	@echo "Missing command. See \`make help'."

help:
	less README.md
# ------------------------------------------------------------------------------

# install
# ------------------------------------------------------------------------------
install: install-required install-core install-optional
uninstall: uninstall-required uninstall-core uninstall-optional

install-required: install-nix \
        install-git
uninstall-required: uninstall-nix \
        uninstall-nix

install-core: install-zsh \
        install-i3wm \
        install-tmux \
        install-tmuxinator \
        install-ranger \
        install-vim
uninstall-core: uninstall-zsh \
        uninstall-i3wm \
        uninstall-tmux \
        uninstall-tmuxinator \
        uninstall-ranger \
        uninstall-vim
        
install-xclip install-htop:
	$(error "Not yet supported: $@.")
# ------------------------------------------------------------------------------

# setup
# ------------------------------------------------------------------------------
setup: setup-required setup-core setup-optional
unsetup: unsetup-required unsetup-core unsetup-optional

setup-required: setup-nix \
        setup-git
unsetup-required: unsetup-nix \
        unsetup-nix

setup-core: setup-zsh \
        setup-i3wm \
        setup-tmux \
        setup-tmuxinator \
        setup-ranger \
        setup-vim
unsetup-core: unsetup-zsh \
        unsetup-i3wm \
        unsetup-tmux \
        unsetup-tmuxinator \
        unsetup-ranger \
        unsetup-vim
        
setup-xclip setup-htop:
	$(error "Not yet supported: $@.")
# ------------------------------------------------------------------------------
