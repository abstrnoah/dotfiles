include ../../header.mk

base_dir = ../..


# setup
# ------------------------------------------------------------------------------
.PHONY: setup
setup: $(HOME)/.tmux.conf

.PHONY: unsetup
unsetup:
	$(call unmake_link,$(HOME)/.tmux.conf)

$(HOME)/.tmux.conf: tmux.conf
	$(make_link)
# ------------------------------------------------------------------------------

# install
# ------------------------------------------------------------------------------
.PHONY: install
install: install_2_1

.PHONY: install_2_1
install_2_1: $(ANENV_NIXPKGS)
	$(call install_nix_pkg\
        ,f608644c23cfcfecbcd98ea20f07164d2ce4b762,tmux)

.PHONY: uninstall
uninstall:
	$(uninstall_nix_pkg) tmux
# ------------------------------------------------------------------------------
