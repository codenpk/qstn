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
  EntryS.get id .then ((e)->
    if !e then return error.four!
    app.title e.question
    @entry = new EntryM e
    c = cookie.get e.slug
    @selected = if c then Number c else null
    @sock = new Sock
    @sock.listen do
      @get.bind @
  ).bind @

# Change
# ~~
# Change selection index
Module::change = (idx)!->
  m.startComputation!
  o = @entry.options
  v = o[idx].votes!
  if @selected != null
    s = o[@selected].votes!
    o[@selected].votes --s
  @selected = idx
  o[idx].votes ++v
  m.endComputation!
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
  # Set cookie
  cookie.set @entry.slug, @selected
  m.startComputation!
  o = @entry.options
  # Replace option votes
  for v, k in data.options
    o[k].votes v.votes
  m.endComputation!

# Unload
# ~~
# Before the route transitions
# this function will be called
Module::onunload = (e)->
  @sock?.kill!
