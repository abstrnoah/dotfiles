SHELL = /bin/bash

ANENV_NIXPKGS=$(HOME)/nixpkgs

rm_cmd = rm -vf

fullpath = $$( readlink -f "$(1)" )

link_cmd = ln -fs
make_link = $(link_cmd) $(call fullpath,$<) "$@"

get_shell = $$( awk -F: '$$1=="'"$$USER"'" {print $$7}' /etc/passwd )

nix_env_i_cmd = nix-env --install --file "$<" --attr "$(1)"
install_nix_pkg = git -C "$<" checkout "$(1)" && $(call nix_env_i_cmd,$(2))

# $(ANENV_NIXPKGS):
#	git clone $(ANENV_MASTERREMOTE)/nixpkgs