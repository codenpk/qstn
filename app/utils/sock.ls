'use strict'

# Sock
# ~~
# New
Sock = module.exports = !->
  @fnc = []
  setTimeout (->
    # It's a race, yo
    id = location.pathname / \/
    @s = new WebSocket do
      "ws:#{location.host}/s/#{id[2]}"
    @bind!
  ).bind(@), 0

# Bind
# ~~
# Bind events
Sock::bind = !->
  @s.onmessage = ((e)->
    return if e.data == \PING
    d = JSON.parse e.data
    for v in @fnc then v d
  ).bind @

# Send
# ~~
# Send data
Sock::send = (val)!->
  @s.send JSON.stringify val

# Listen
# ~~
# Add a handler to get
# data from the socket
Sock::listen = (fnc)!->
  @fnc.push fnc

# Kill
# ~~
# Close socket
Sock::kill = !->
  @s.close!
