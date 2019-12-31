include ../../header.mk
.PHONY = missing_command install

missing_command:
	$(error "Missing command. See README.md")

# setup
# ------------------------------------------------------------------------------
setup: $(HOME)/.gitconfig

$(HOME)/.gitconfig: gitconfig
	$(make_link)
# ------------------------------------------------------------------------------

# install
# ------------------------------------------------------------------------------
install: install_2_24_1

install_2_24_1: $(ANENV_NIXPKGS)
	$(call install_nix_pkg\
        ,62ef779f2a5050549772722665bedf52f01268d2,gitAndTools.gitFull)

uninstall:
	$(uninstall_nix_pkg) git
# ------------------------------------------------------------------------------
