require! {
  \mithril               : m
  \./model.ls            : Model
  \../../stores/entry.ls : EntryS
  \../../models/entry.ls : EntryM
  \../../utils/app.ls    : app
}

# Controller
# ~~
# Module controller
Module = module.exports = !->
  app.title 'Create and share \
  polls and get live results'
  @froze = Model.froze
  @entry = new EntryM do
    Model.entry

# Filled
# ~~
# The number of option inputs
# that actually have content
Module::filled = ->
  n = 0
  l = @entry.options.length
  for v, k in @entry.options
    n++ if v.option!.trim! != ''
  n

# Frozen
# ~~
# If the question isn't empty
# and the @filled count is at
# least 2 we can submit
Module::frozen = !->
  @froze = @entry.question!.trim! == '' or @filled! < 2

# Watch
# ~~
# Watches the inputs onkeyup
# and determines whether an option
# needs to be pushed or popped
Module::watch = (item)!->
  n = @filled!
  l = @entry.options.length

  switch true
  | n + 2 == l != 2
    @entry.pop!
  | n == l
    @entry.push!

  @frozen.call @


# Ship
# ~~
# Sends a POST request to /q and
# redirect to the new entry
Module::ship = (e)!->
  e.preventDefault()
  # Clone and pop @entry
  copy = {[k,v] for k,v of @entry}
  copy.options.pop!
  # Submit @entry
  EntryS.post copy .then (res)!->
    m.route "/q/#{res.slug}"
