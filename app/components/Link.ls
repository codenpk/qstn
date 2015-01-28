'use strict'

require! \lodash  : _
require! \page    : Page
require! \mithril : m

to = (e) !->
  e.preventDefault!
  h = e.target.getAttribute \href
  Page h unless location.pathname == h

# View
# ~~
module.exports = (ctrl, body) ->
  # Build arguments
  args = _.extend do
    onclick: to
    ctrl

  m \a, args, body
