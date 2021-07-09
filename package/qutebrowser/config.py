# qutebrowser/config.py - qutebrowser runtime configuration

# Documentation:
#   qute://help/configuring.html
#   qute://help/settings.html

__author__ = "abstractednoah"
__email__ = "abstractednoah@brumal.org"

# SETUP {{{1

# Home page.
# Note that 'start_pages' is different from 'default_page'; ':home' goes to the
# former while generic opens go to the latter.
c.url.start_pages = ["https://www.nytimes.com/"]

# Don't load autoconfig.yml.
config.load_autoconfig(False)

# Editor (and arguments) to use for the `edit-*` commands.
c.editor.command = ["gvim", "-f", "{file}", "-c", "normal {line}G{column0}l"]

# Position of the tab bar.
c.tabs.position = "top"

# DARKMODE {{{1

# Value to use for `prefers-color-scheme:` for websites.
c.colors.webpage.preferred_color_scheme = "dark"

# Render all web contents using a dark theme.
c.colors.webpage.darkmode.enabled = False

# Which algorithm to use for modifying how colors are rendered with
# darkmode.
c.colors.webpage.darkmode.algorithm = "lightness-hsl"

# Contrast for dark mode.
c.colors.webpage.darkmode.contrast = 0.0

# Render all colors as grayscale.
c.colors.webpage.darkmode.grayscale.all = True

# Desaturation factor for images in dark mode.
c.colors.webpage.darkmode.grayscale.images = 1.0

# PER-DOMAIN SETTINGS {{{1
with config.pattern("https://mail.google.com/") as p:
    p.content.notifications = True
with config.pattern("https://mail.google.com?extsrc=mailto&url=%25s") as p:
    p.content.register_protocol_handler = True

with config.pattern("https://calendar.google.com/") as p:
    p.content.notifications = True
with config.pattern("https://calendar.google.com?cid=%25s") as p:
    p.content.register_protocol_handler = True

# BINDS {{{1

# Don't forward any keys to page unless in an insert mode.
c.input.forward_unbound_keys = "none"

# Default tab movement is to the end (right-most).
config.bind("gm", "tab-move -1")

# Swap quickmark and mark for more vim-like experience.
config.bind("m", "mode-enter set_mark")
config.bind("`", "quickmark-save")

# Open current page in mpv.
config.bind(",v", "spawn mpv {url}")

# Passthrough mode.
# <Escape> always escapes to normal.
config.bind("<Escape>", "mode-leave", mode="passthrough")
# Toggle behavior of ^[ between mode-leave and passthru <Escape>.
# We need a userscript because this implementation of toggling is inherently
# recursive (unsure how else to do such a toggle with qutebrowser).
# See 'toggle-esc --help' for more info.
config.bind("<Ctrl-[>", "mode-leave", mode="passthrough")
config.bind(
    "<Shift-Escape>",
    "spawn --userscript toggle-esc passthru",
    mode="passthrough",
)

# Passthrough common clipboard chords.
config.bind(",y", "fake-key <Ctrl-c>")
config.bind(",p", "fake-key <Ctrl-v>")
config.bind(",d", "fake-key <Ctrl-x>")

# Passthrough escape in normal.
config.bind(",e", "fake-key <Escape>")

# Passthrough common undo chords.
config.bind(",u", "fake-key <Ctrl-z>")
config.bind(",r", "fake-key <Ctrl-y>")

# Passthrough search.
config.bind(",/", "fake-key <Ctrl-f>")

# Advanced history navigation.
# NOTE: These use the 'g' leader, so might end up conflicting with future
# versions of QB.
config.bind("gH", "set-cmd-text -s :back")
config.bind("gL", "set-cmd-text -s :forward")
