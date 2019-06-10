local settings = require "settings"

settings.window.home_page = "http://xkcd.com"

local engines = settings.window.search_engines
engines.ddg = "https://duckduckgo.com/?q=%s"
engines.g = "https://google.com/search?q=%s"
engines.default = engines.ddg
