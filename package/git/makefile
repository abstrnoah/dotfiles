include ../../header.mk

# setup
# ------------------------------------------------------------------------------
.PHONY: setup
setup: $(HOME)/.gitconfig

.PHONY: unsetup
unsetup:
	$(call unmake_link,$(HOME)/.gitconfig)

$(HOME)/.gitconfig: gitconfig
	$(make_link)
# ------------------------------------------------------------------------------

# install
# ------------------------------------------------------------------------------
.PHONY: install
install: install_2_24_1

.PHONY: install_2_24_1
install_2_24_1: $(ANENV_NIXPKGS)
	$(call install_nix_pkg\
        ,62ef779f2a5050549772722665bedf52f01268d2,gitAndTools.gitFull)

.PHONY: uninstall
uninstall:
	$(uninstall_nix_pkg) git
# ------------------------------------------------------------------------------
