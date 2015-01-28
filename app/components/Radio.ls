'use strict'

require! \lodash  : _
require! \mithril : m

# View
# ~~
module.exports = (ctrl, body) ->
  # Build arguments
  args = _.extend do
    type: \radio
    ctrl

  m \.radio,
    m \input, args
    m \label,
      for: args.id
      ''
