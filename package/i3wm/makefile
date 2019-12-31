base_dir = ../..

include $(base_dir)/header.mk

# setup
# ------------------------------------------------------------------------------
.PHONY: setup
setup: $(HOME)/.config/i3/config $(HOME)/.i3status.conf setup-wallpaper

.PHONY: unsetup
unsetup: unsetup-wallpaper
	$(call unmake_link,$(HOME)/.config/i3/config)
	$(call unmake_link,$(HOME)/.i3status.conf)

$(HOME)/.config/i3/config: i3wm.conf
	$(make_link)

$(HOME)/.i3status.conf: i3status.conf
	$(make_link)

.PHONY: setup-wallpaper
setup-wallpaper:
	$(MAKE) -C $(base_dir) setup-wallpaper

.PHONY: unsetup-wallpaper
unsetup-wallpaper:
	$(MAKE) -C $(base_dir) unsetup-wallpaper
# ------------------------------------------------------------------------------

# install
# ------------------------------------------------------------------------------
.PHONY: install
install: # install_4_11
	$(error_unsupported)

.PHONY: install_4_11
install_4_11: $(ANENV_NIXPKGS)
	$(call install_nix_pkg\
        ,ebd656653458fd6f7d5c85c9e6e0ec834eff3855,i3)

.PHONY: uninstall
uninstall:
	$(error_unsupported)
#	$(uninstall_nix_pkg) i3
# ------------------------------------------------------------------------------
