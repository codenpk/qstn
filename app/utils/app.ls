'use strict'

require! \mithril : m

# Title
# ~~
exports.title = (v)!->
  x = document.title / ' | '; x[0] = v
  document.title = x * ' | '
