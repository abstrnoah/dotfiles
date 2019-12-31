include ../../header.mk
                    # TODO: ensure directories exist.
# setup
# ------------------------------------------------------------------------------
.PHONY: setup
setup: $(HOME)/.zshrc $(HOME)/.zshenv

.PHONY: unsetup
unsetup:
	$(call unmake_link,$(HOME)/.zshrc)
	$(call unmake_link,$(HOME)/.zshenv)

$(HOME)/.zshrc: zshrc
	$(make_link)

$(HOME)/.zshenv: zshenv
	$(make_link)
# ------------------------------------------------------------------------------

# install
# ------------------------------------------------------------------------------
.PHONY: install
install: install_5_1_1

.PHONY: install_5_1_1
install_5_1_1: $(ANENV_NIXPKGS)
	$(call install_nix_pkg\
        ,97332d30f62b149aa81a63f798e7e53825e12663,zsh)

.PHONY: uninstall
uninstall:
	$(uninstall_nix_pkg) zsh
# ------------------------------------------------------------------------------
