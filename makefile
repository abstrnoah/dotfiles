.PHONY = all mkdirs bash zsh vim wm wallpaper tmux

DIRDEPS = $(HOME)/.vim $(HOME)/.config/i3

fullpath = $$( readlink -f "$(1)" )
link = ln -fs
makelink = $(link) $(call fullpath,$<) "$@"


all: mkdirs bash zsh vim wm tmux

mkdirs:
	mkdir -p $(DIRDEPS)

# shell
# ------------------------------------------------------------------------------
bash: $(HOME)/.bashrc $(HOME)/.bash_aliases

$(HOME)/.bashrc: shell/bashrc
	$(makelink)

$(HOME)/.bash_aliases: shell/bash_aliases
	$(makelink)

zsh: $(HOME)/.zshrc

$(HOME)/.zshrc: shell/zshrc
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

$(HOME)/.config/i3/config: wm/i3wm.config $(HOME)/.config/i3/keybinds
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
tmux: $(HOME)/.tmuxinator $(HOME)/.tmux.conf \
		/usr/lib/ruby/vendor_ruby/tmuxinator/assets/sample.yml

$(HOME)/.tmuxinator: tmux/mux/projects
	$(makelink)

$(HOME)/.tmux.conf: tmux/tmux.conf
	$(makelink)

/usr/lib/ruby/vendor_ruby/tmuxinator/assets/sample.yml: tmux/mux/sample.yml
	sudo $(makelink)
# ------------------------------------------------------------------------------
