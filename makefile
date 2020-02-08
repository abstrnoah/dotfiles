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
        install-tmux \
        install-tmuxinator \
        install-vim

.PHONY: uninstall-core
uninstall-core: uninstall-zsh \
        uninstall-tmux \
        uninstall-tmuxinator \
        uninstall-vim

.PHONY: install-optional
install-optional: install-visidata

.PHONY: uninstall-optional
uninstall-optional: uninstall-visidata

install-xclip install-nix install-ranger:
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
        setup-vim \
        setup-nix

.PHONY: unsetup-core
unsetup-core: unsetup-zsh \
        unsetup-i3wm \
        unsetup-tmux \
        unsetup-tmuxinator \
        unsetup-vim \
        unsetup-nix
        
.PHONY: setup-optional
setup-optional: setup-visidata

.PHONY: unsetup-optional
unsetup-optional: unsetup-visidata

setup-xclip :
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

# instatiate git
# ------------------------------------------------------------------------------
.PHONY: install-git
install-git:
	$(MAKE) -C package/git install  # TODO: pass environment to $(MAKE) -C 's

.PHONY: uninstall-git
uninstall-git:
	$(MAKE) -C package/git uninstall

.PHONY: setup-git
setup-git:
	$(MAKE) -C package/git setup

.PHONY: unsetup-git
unsetup-git:
	$(MAKE) -C package/git unsetup
# ------------------------------------------------------------------------------

# instatiate htop
# ------------------------------------------------------------------------------
.PHONY: install-htop
install-htop:
	$(MAKE) -C package/htop install

.PHONY: uninstall-htop
uninstall-htop:
	$(MAKE) -C package/htop uninstall

.PHONY: setup-htop
setup-htop:
	$(MAKE) -C package/htop setup

.PHONY: unsetup-htop
unsetup-htop:
	$(MAKE) -C package/htop unsetup
# ------------------------------------------------------------------------------

# instatiate i3wm
# ------------------------------------------------------------------------------
.PHONY: install-i3wm
install-i3wm:
	$(MAKE) -C package/i3wm install

.PHONY: uninstall-i3wm
uninstall-i3wm:
	$(MAKE) -C package/i3wm uninstall

.PHONY: setup-i3wm
setup-i3wm:
	$(MAKE) -C package/i3wm setup

.PHONY: unsetup-i3wm
unsetup-i3wm:
	$(MAKE) -C package/i3wm unsetup
# ------------------------------------------------------------------------------

# instatiate tmux
# ------------------------------------------------------------------------------
.PHONY: install-tmux
install-tmux:
	$(MAKE) -C package/tmux install

.PHONY: uninstall-tmux
uninstall-tmux:
	$(MAKE) -C package/tmux uninstall

.PHONY: setup-tmux
setup-tmux:
	$(MAKE) -C package/tmux setup

.PHONY: unsetup-tmux
unsetup-tmux:
	$(MAKE) -C package/tmux unsetup
# ------------------------------------------------------------------------------

# instatiate tmuxinator
# ------------------------------------------------------------------------------
.PHONY: install-tmuxinator
install-tmuxinator:
	$(MAKE) -C package/tmuxinator install

.PHONY: uninstall-tmuxinator
uninstall-tmuxinator:
	$(MAKE) -C package/tmuxinator uninstall

.PHONY: setup-tmuxinator
setup-tmuxinator:
	$(MAKE) -C package/tmuxinator setup

.PHONY: unsetup-tmuxinator
unsetup-tmuxinator:
	$(MAKE) -C package/tmuxinator unsetup
# ------------------------------------------------------------------------------


# instatiate vim
# ------------------------------------------------------------------------------
.PHONY: install-vim
install-vim:
	$(MAKE) -C package/vim install

.PHONY: uninstall-vim
uninstall-vim:
	$(MAKE) -C package/vim uninstall

.PHONY: setup-vim
setup-vim:
	$(MAKE) -C package/vim setup

.PHONY: unsetup-vim
unsetup-vim:
	$(MAKE) -C package/vim unsetup
# ------------------------------------------------------------------------------

# instatiate visidata
# ------------------------------------------------------------------------------
.PHONY: install-visidata
install-visidata:
	$(MAKE) -C package/visidata install

.PHONY: uninstall-visidata
uninstall-visidata:
	$(MAKE) -C package/visidata uninstall

.PHONY: setup-visidata
setup-visidata:
	$(MAKE) -C package/visidata setup

.PHONY: unsetup-visidata
unsetup-visidata:
	$(MAKE) -C package/visidata unsetup
# ------------------------------------------------------------------------------

# instatiate zsh
# ------------------------------------------------------------------------------
.PHONY: install-zsh
install-zsh:
	$(MAKE) -C package/zsh install

.PHONY: uninstall-zsh
uninstall-zsh:
	$(MAKE) -C package/zsh uninstall

.PHONY: setup-zsh
setup-zsh:
	$(MAKE) -C package/zsh setup

.PHONY: unsetup-zsh
unsetup-zsh:
	$(MAKE) -C package/zsh unsetup
# ------------------------------------------------------------------------------

# instatiate nix
# ------------------------------------------------------------------------------
.PHONY: setup-nix
setup-nix:
	$(MAKE) -C package/nix setup

.PHONY: unsetup-nix
unsetup-nix:
	$(MAKE) -C package/nix unsetup
# ------------------------------------------------------------------------------
