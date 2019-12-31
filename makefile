include header.mk
.PHONY = missing_command help all all-undo install install-undo setup setup-undo


# ------------------------------------------------------------------------------
missing_command: help
	@echo "Missing command. See \`make help'."

help:
	less README.md
# ------------------------------------------------------------------------------

# all
# ------------------------------------------------------------------------------
all: install setup
all-undo: install-undo setup-undo
# ------------------------------------------------------------------------------

# install
# ------------------------------------------------------------------------------
install: install-required install-core install-optional
install-undo: install-required-undo install-core-undo install-optional-undo

install-required: install-nix \
        install-git
install-required-undo: install-nix-undo \
        install-nix-undo

install-core: install-zsh \
        install-i3wm \
        install-tmux \
        install-tmuxinator \
        install-ranger \
        install-vim
install-core-undo: install-zsh-undo \
        install-i3wm-undo \
        install-tmux-undo \
        install-tmuxinator-undo \
        install-ranger-undo \
        install-vim-undo
        
install-xclip install-htop:
	$(error "Not yet supported: $@.")
# ------------------------------------------------------------------------------

# setup
# ------------------------------------------------------------------------------
setup: setup-required setup-core setup-optional
setup-undo: setup-required-undo setup-core-undo setup-optional-undo

setup-required: setup-nix \
        setup-git
setup-required-undo: setup-nix-undo \
        setup-nix-undo

setup-core: setup-zsh \
        setup-i3wm \
        setup-tmux \
        setup-tmuxinator \
        setup-ranger \
        setup-vim
setup-core-undo: setup-zsh-undo \
        setup-i3wm-undo \
        setup-tmux-undo \
        setup-tmuxinator-undo \
        setup-ranger-undo \
        setup-vim-undo
        
setup-xclip setup-htop:
	$(error "Not yet supported: $@.")
# ------------------------------------------------------------------------------
