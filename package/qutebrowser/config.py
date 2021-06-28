# qutebrowser/config.py - qutebrowser runtime configuration

# Documentation:
#   qute://help/configuring.html
#   qute://help/settings.html

__author__ = "abstractednoah"
__email__ = "abstractednoah@brumal.org"

# SETUP {{{1

# Don't load autoconfig.yml.
config.load_autoconfig(False)

# Editor (and arguments) to use for the `edit-*` commands.
c.editor.command = ['gvim', '-f', '{file}', '-c', 'normal {line}G{column0}l']

# Position of the tab bar.
c.tabs.position = 'top'

# DARKMODE {{{1

# Value to use for `prefers-color-scheme:` for websites.
c.colors.webpage.preferred_color_scheme = 'dark'

# Render all web contents using a dark theme.
c.colors.webpage.darkmode.enabled = False

# Which algorithm to use for modifying how colors are rendered with
# darkmode.
c.colors.webpage.darkmode.algorithm = 'lightness-hsl'

# Contrast for dark mode.
c.colors.webpage.darkmode.contrast = 0.0

# Render all colors as grayscale.
c.colors.webpage.darkmode.grayscale.all = True

# Desaturation factor for images in dark mode.
c.colors.webpage.darkmode.grayscale.images = 1.0

# MAPS {{{1

# Default tab movement is to the end (right-most).
config.bind("gm", "tab-move -1")

# Swap quickmark and mark for more vim-like experience.
config.bind("m", "mode-enter set_mark")
config.bind("`", "quickmark-save")

# Open current page in mpv.
config.bind(",v", "spawn mpv {url}")

# Passthrough mode.
config.bind("<Ctrl-[>", "mode-leave", mode="passthrough")
