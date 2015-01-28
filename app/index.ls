'use strict'

require! \mithril : m
require! \page : Page

require! \./entries/index.ls : entries
require! \./errors/index.ls  : errors

# First
# ~~
# Boolean which determines whether
# it's the first request or not
# (to not send to ga twice)
first = false

# Render
# ~~
# Swap main body module
render = (c) !-> m.module document.body, c

# gaPush
# ~~
# Let's Google Analytics know when
# there's been a page transition
gaPush = (ctx, next) !->
  return !(first = false) && next! if first
  ga \send, \pageview, page: "/#{ctx.pathname}"
  next!

# routes
# ~~
routes =
  \/      : entries.index
  \/q/:id : entries.show
  \*      : errors.four

# Build route handlers
for key, val of routes
  ((val) ->
    f = !(ctx) ->
      # TODO: Get content into controllers
      render val ctx
    Page.apply @, [
      key,
      gaPush
      f
    ]
  ) val

setTimeout ->
  Page click: false
, 0
