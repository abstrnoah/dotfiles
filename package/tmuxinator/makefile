base_dir = ../..

include $(base_dir)/header.mk

# setup
# ------------------------------------------------------------------------------
.PHONY: setup
setup: $(HOME)/.tmuxinator

.PHONY: unsetup
unsetup:
	$(rm_cmd) -r $(HOME)/.tmuxinator  # rm because mux autogens the folder.

$(HOME)/.tmuxinator: projects
	$(make_link)
# ------------------------------------------------------------------------------

# install
# ------------------------------------------------------------------------------
.PHONY: install
install: install_1_1_0

.PHONY: install_1_1_0
install_1_1_0: $(ANENV_NIXPKGS)
	$(call install_nix_pkg\
        ,62ef779f2a5050549772722665bedf52f01268d2,tmuxinator)

.PHONY: uninstall
uninstall:
	$(uninstall_nix_pkg) tmuxinator
# ------------------------------------------------------------------------------
