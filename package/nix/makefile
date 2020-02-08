include ../../header.mk

base_dir = ../..


                    # TODO: ensure directories exist.
# setup
# ------------------------------------------------------------------------------
.PHONY: setup
setup: $(HOME)/.config/nixpkgs/config.nix

.PHONY: unsetup
unsetup:
	$(call unmake_link,$(HOME)/.config/nixpkgs)

$(HOME)/.config/nixpkgs/config.nix: config.nix
	$(make_link)
# ------------------------------------------------------------------------------

# install
# ------------------------------------------------------------------------------
.PHONY: install
install: error_unsupported

.PHONY: uninstall
uninstall: error_unsupported
# ------------------------------------------------------------------------------
