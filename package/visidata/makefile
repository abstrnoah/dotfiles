include ../../header.mk

base_dir = ../..


# setup
# ------------------------------------------------------------------------------
.PHONY: setup
setup: $(HOME)/.visidatarc

.PHONY: unsetup
unsetup:
	$(call unmake_link,$(HOME)/.visidatarc)

$(HOME)/.visidatarc: visidatarc
	$(make_link)
# ------------------------------------------------------------------------------

# install
# ------------------------------------------------------------------------------
.PHONY: install
install: install_1_5_2

.PHONY: install_1_5_2
install_1_5_2: $(ANENV_NIXPKGS)
	$(call install_nix_pkg\
        ,bfaed0926f1c336fbcf1ac2466e7f7d30ada56b9,visidata)

.PHONY: uninstall
uninstall:
	$(uninstall_nix_pkg) visidata
# ------------------------------------------------------------------------------
