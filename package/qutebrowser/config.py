# qutebrowser/config.py - qutebrowser runtime configuration

# Documentation:
#   qute://help/configuring.html
#   qute://help/settings.html

__author__ = "abstractednoah"
__email__ = "abstractednoah@brumal.org"

# GLOBALS {{{1

# Leader keys by functionality.
_leader = ","
_leader_tab = "<Ctrl-t>"
_leader_hint = _leader + ";"

# SETUP {{{1

# Home page.
# Note that 'start_pages' is different from 'default_page'; ':home' goes to the
# former while generic opens go to the latter.
c.url.start_pages = ["https://start.duckduckgo.com/"]

# Don't load autoconfig.yml.
config.load_autoconfig(False)

# Editor (and arguments) to use for the `edit-*` commands.
c.editor.command = ["gvim", "-f", "{file}", "-c", "normal {line}G{column0}l"]

# Position of the tab bar.
c.tabs.position = "top"

# Close tab even if it's the last tab.
c.tabs.last_close = "close"

# Autoplay sucks.
c.content.autoplay = False

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
    p.content.notifications.enabled = True
with config.pattern("https://mail.google.com?extsrc=mailto&url=%25s") as p:
    p.content.register_protocol_handler = True

with config.pattern("https://calendar.google.com/") as p:
    p.content.notifications.enabled = True
with config.pattern("https://calendar.google.com?cid=%25s") as p:
    p.content.register_protocol_handler = True

# BINDS {{{1

# Unbind some annoying keys.
config.unbind("<Ctrl-a>")

# Don't forward any keys to page unless in an insert mode.
c.input.forward_unbound_keys = "none"

# Resource config.
config.bind(_leader + "C", "config-source")

# Swap quickmark and mark for more vim-like experience.
config.bind("m", "mode-enter set_mark")
config.bind("`", "quickmark-save")

# Open current page in mpv.
config.bind(_leader + "v", "spawn mpv {url}")
# Open link in mpv.
config.bind(_leader_hint + "v", "hint all spawn mpv {hint-url}")

# Open current page in firefox (I'm sorry).
config.bind(_leader + "F", "spawn firefox {url}")

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
config.bind(_leader + "y", "fake-key <Ctrl-c>")
config.bind(_leader + "p", "fake-key <Ctrl-v>")
config.bind(_leader + "d", "fake-key <Ctrl-x>")

# Passthrough escape in normal.
config.bind(_leader + "e", "fake-key <Escape>")

# Passthrough common undo chords.
config.bind(_leader + "u", "fake-key <Ctrl-z>")
config.bind(_leader + "r", "fake-key <Ctrl-y>")

# Passthrough search.
config.bind(_leader + "/", "fake-key <Ctrl-f> ;; mode-enter insert")

# History navigation.
config.unbind("H")
config.unbind("L")
config.bind("gh", "back")
config.bind("gl", "forward")
config.bind("gH", "set-cmd-text -s :back")
config.bind("gL", "set-cmd-text -s :forward")

# Tab navigation.
config.unbind("d")
config.unbind("D")
config.unbind("<Ctrl-w>")
config.unbind(_leader_tab)
config.unbind("r")
config.unbind("R")
config.bind(_leader_tab + "n", "open -t")
config.bind(_leader_tab + "q", "tab-close")
config.bind(_leader_tab + "r", "reload")
config.bind(_leader_tab + "R", "reload -f")
# Tab movement to the end (right-most).
config.bind("gm", "tab-move -1")
# Move (give) to window, prompt.
config.bind("gD", "set-cmd-text -s :tab-give")

# Clear messages on the fly.
config.bind("cm", "clear-messages")
