SHELL = /bin/bash

base_dir = .

ANENV_NIXPKGS=$(HOME)/nixpkgs
ANENV_WALLPAPER=./share/wallpaper-home.png
ANENV_WALLPAPER_LOCK=./share/wallpaper-lock.png

rm_cmd = rm -vf

fullpath = $$( readlink -f "$(1)" )

link_cmd = ln -fs
make_link = $(link_cmd) $(call fullpath,$<) "$@"
unmake_link = [ ! -L $(1) ] || $(rm_cmd) $(1)

get_shell = $$( awk -F: '$$1=="'"$$USER"'" {print $$7}' /etc/passwd )

nix_env_i_cmd = nix-env --install --file "$<" --attr "$(1)"
nix_env_e_cmd = nix-env --uninstall
install_nix_pkg = git -C "$<" checkout "$(1)" && $(call nix_env_i_cmd,$(2))
uninstall_nix_pkg = $(nix_env_e_cmd)

error_unsupported = $(error "Not yet supported: $@.")


# missing_command must be first rule in all makefiles.
.PHONY: missing_command
missing_command:
	$(error "Missing command. See README.md")

# all
# ------------------------------------------------------------------------------
all: setup-anenv install setup
unall: unsetup-anenv uninstall unsetup
# ------------------------------------------------------------------------------

# setup-anenv
# ------------------------------------------------------------------------------
.PHONY: setup-anenv
setup-anenv: $(HOME)/.dotfiles

.PHONY: unsetup-anenv
unsetup-anenv:
	@echo "Manually rm ~/.dotfiles (not doing it automatically to avoid doing"\
            "some real damage)."

$(HOME)/.dotfiles: $(base_dir)
	$(make_link)

# ------------------------------------------------------------------------------

# $(ANENV_NIXPKGS):
#	git clone $(ANENV_MASTERREMOTE)/nixpkgs
