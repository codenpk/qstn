'use strict'

require! \lodash  : _
require! \mithril : m

# View
# ~~
module.exports = (ctrl, body) ->
  # Build arguments
  args = _.extend do
    contenteditable: true
    ctrl

  m \div, args, body
