include ../../header.mk
                    # TODO: ensure directories exist.
# setup
# ------------------------------------------------------------------------------
.PHONY: setup
setup: $(HOME)/.vimrc $(HOME)/.vim/plugin

.PHONY: unsetup
unsetup:
	$(call unmake_link,$(HOME)/.vimrc)
	$(call unmake_link,$(HOME)/.vim/plugin)

$(HOME)/.vimrc: vimrc
	$(make_link)

$(HOME)/.vim/plugin: plugin
	$(make_link)
# ------------------------------------------------------------------------------

# install
# ------------------------------------------------------------------------------
.PHONY: install
install: install_7_4_826

.PHONY: install_7_4_826
install_7_4_826: $(ANENV_NIXPKGS)
	$(call install_nix_pkg\
        ,4d82228a63549c5896fe5e73b06178b37e349dde,vimHugeX)

.PHONY: uninstall
uninstall:
	$(uninstall_nix_pkg) vim_configurable
# ------------------------------------------------------------------------------
