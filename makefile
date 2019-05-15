.PHONY = all mkdirs bash vim wm wallpaper tmux

DIRDEPS = $(HOME)/.vim $(HOME)/.config/i3

fullpath = $$( readlink -f "$(1)" )
link = ln -fs
makelink = $(link) $(call fullpath,$<) "$@"


all: mkdirs bash vim wm tmux

mkdirs:
	mkdir -p $(DIRDEPS)

# bash
# ------------------------------------------------------------------------------
bash: $(HOME)/.bashrc $(HOME)/.bash_aliases

$(HOME)/.bashrc: bash/bashrc
	$(makelink)

$(HOME)/.bash_aliases: bash/bash_aliases
	$(makelink)

# ------------------------------------------------------------------------------

# vim
# ------------------------------------------------------------------------------
vim: $(HOME)/.vimrc $(HOME)/.vim/plugin

$(HOME)/.vimrc: vim/vimrc
	$(makelink)

$(HOME)/.vim/plugin: vim/plugin
	$(makelink)
# ------------------------------------------------------------------------------

# wm
# ------------------------------------------------------------------------------
wm: $(HOME)/.config/i3/config wallpaper $(HOME)/.i3status.conf

wallpaper: $(HOME)/.wallpaper $(HOME)/.wallpaperlock

$(HOME)/.config/i3/config: wm/i3wm.config
	$(makelink)

$(HOME)/.config/i3/keybinds: wm/keybinds
	$(makelink)

$(HOME)/.wallpaper: wm/wallpaper-home.png
	$(makelink)

$(HOME)/.wallpaperlock: wm/wallpaper-lock.png
	$(makelink)

$(HOME)/.i3status.conf: wm/i3status.conf
	$(makelink)

# tmux
# ------------------------------------------------------------------------------
tmux: $(HOME)/.tmuxinator $(HOME)/.tmux.conf

$(HOME)/.tmuxinator: tmux/mux
	$(makelink)

$(HOME)/.tmux.conf: tmux/tmux.conf
	$(makelink)
# ------------------------------------------------------------------------------
