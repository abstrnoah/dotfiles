include ../../header.mk

base_dir = ../..


# setup
# ------------------------------------------------------------------------------
.PHONY: setup
setup: $(HOME)/.config/htop/htoprc

.PHONY: unsetup
unsetup:
	$(call unmake_link,$(HOME)/.config/htop/htoprc)

$(HOME)/.config/htop/htoprc: htoprc
	$(make_link)
# ------------------------------------------------------------------------------

# install
# ------------------------------------------------------------------------------
.PHONY: install
install: install_2_0_1

.PHONY: install_2_0_1
install_2_0_1: $(ANENV_NIXPKGS)
	$(call install_nix_pkg\
        ,8593eb92e837b3806536211db01cefba2f45994b,htop)

.PHONY: uninstall
uninstall:
	$(uninstall_nix_pkg) htop
# ------------------------------------------------------------------------------
