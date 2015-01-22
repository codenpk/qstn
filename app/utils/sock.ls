require! {
  \../config.ls : config
}

# Sock
# ~~
# New
Sock = module.exports = !->
  @fnc = []
  @s = new WebSocket do
    config.sock
  @bind!

# Bind
# ~~
# Bind events
Sock::bind = !->
  @s.onmessage = ((e)->
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
