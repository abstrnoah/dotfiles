include header.mk


# ------------------------------------------------------------------------------
.PHONY: help
help:
	less README.md
# ------------------------------------------------------------------------------

# install
# ------------------------------------------------------------------------------
.PHONY: install
install: install-required install-core install-optional

.PHONY: uninstall
uninstall: uninstall-required uninstall-core uninstall-optional

.PHONY: install-required
install-required: install-git

.PHONY: uninstall-required
uninstall-required: uninstall-git

.PHONY: install-core
install-core: install-zsh \
        install-i3wm \
        install-tmux \
        install-tmuxinator \
        install-vim

.PHONY: uninstall-core
uninstall-core: uninstall-zsh \
        uninstall-i3wm \
        uninstall-tmux \
        uninstall-tmuxinator \
        uninstall-vim
        
install-xclip install-htop install-nix install-ranger:
	$(error "Not yet supported: $@.")
# ------------------------------------------------------------------------------

# setup
# ------------------------------------------------------------------------------
.PHONY: setup
setup: setup-required setup-core setup-optional

.PHONY: unsetup
unsetup: unsetup-required unsetup-core unsetup-optional

.PHONY: setup-required
setup-required: setup-git

.PHONY: unsetup-required
unsetup-required: unsetup-git

.PHONY: setup-core
setup-core: setup-zsh \
        setup-i3wm \
        setup-tmux \
        setup-tmuxinator \
        setup-vim

.PHONY: unsetup-core
unsetup-core: unsetup-zsh \
        unsetup-i3wm \
        unsetup-tmux \
        unsetup-tmuxinator \
        unsetup-vim
        
setup-xclip setup-htop:
	$(error "Not yet supported: $@.")
# ------------------------------------------------------------------------------

# other setup
# ------------------------------------------------------------------------------
.PHONY: setup-wallpaper
setup-wallpaper: $(HOME)/.wallpaper $(HOME)/.wallpaperlock

.PHONY: unsetup-wallpaper
unsetup-wallpaper:
	$(call unmake_link,$(HOME)/.wallpaper)
	$(call unmake_link,$(HOME)/.wallpaperlock)

$(HOME)/.wallpaper: $(ANENV_WALLPAPER)
	$(make_link)

$(HOME)/.wallpaperlock: $(ANENV_WALLPAPER_LOCK)
	$(make_link)
# ------------------------------------------------------------------------------
