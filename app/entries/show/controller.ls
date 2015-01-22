require! {
  \mithril               : m
  \./model.ls            : Model
  \../../utils/sock.ls   : Sock
  \../../stores/entry.ls : EntryS
  \../../models/entry.ls : EntryM
  \../../utils/cookie.ls : cookie
  \../../utils/error.ls  : error
  \../../utils/app.ls    : app
}

# Controller
# ~~
# Module controller
Module = module.exports = !->
  id = m.route.param \id
  # Resolve the entry first
  EntryS.get id .then ((e)->
    if !e then return error.four!
    # Update title
    app.title e.question
    # New Entry instance
    @entry = new EntryM e
    # Value from cookie
    c = cookie.get e.slug
    # Convert cookie value to number
    @selected = if c then Number c else null
    # New socket
    @sock = new Sock
    console.log 'New Socket: ' + new Date
    # Listen
    @sock.listen do
      @get.bind @
  ).bind @

# Change
# ~~
# Change selection index
Module::change = (idx)!->
  console.log 'Change start: ' + new Date
  m.startComputation!
  o = @entry.options
  v = o[idx].votes!

  if @selected != null
    s = o[@selected].votes!
    o[@selected].votes --s

  cookie.set @entry.slug, idx

  @selected = idx

  o[idx].votes ++v
  m.endComputation!
  console.log 'Change end: ' + new Date

  console.log 'Sending data: ' + new Date
  @sock.send @entry


# Perc
# ~~
# Vote percentage
Module::perc = (obj)->
  n = 0
  for v in @entry.options
    n += v.votes!
  n = obj.votes! / n * 100
  (n ||= 0).toFixed 0

# Get
# ~~
# Data recieved from socket
Module::get = (data)!->
  console.log 'Retrieved data: ' + new Date
  m.startComputation!
  o = @entry.options
  console.log 'Updating values: ' + new Date
  # Replace option votes
  for v, k in data.options
    o[k].votes v.votes
  m.endComputation!
  console.log 'Updated values: ' + new Date

# Unload
# ~~
# Before the route transitions
# this function will be called
Module::onunload = (e)->
  console.log 'Closed socket: ' + new Date
  # Close socket, memory
  # leaks are bad, yo!
  @sock.kill!
