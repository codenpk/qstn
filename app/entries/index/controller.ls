'use strict'

require! \mithril : m
require! \page    : Page

require! \./Model.ls
require! \../../stores/EntryStore.ls
require! \../../models/EntryModel.ls
require! \../../utils/app.ls

# Controller
# ~~
Module = module.exports = !->
  app.title 'Create and share \
  polls and get live results'
  @ready = Model.ready
  @entry = new EntryModel do
    Model.entry

# Filled
# ~~
# The number of option inputs
# that actually have content
Module::filled = ->
  n = 0
  l = @entry.options.length
  for v, k in @entry.options
    n++ if /\S/.test v.option!
  n

# Question Change
# ~~
# Change the question value
Module::questionChange = (e) !->
  @entry.question e.target.textContent

# Option Change
# ~~
# Change an option's value
Module::optionChange = (item, e) !->
  item.option e.target.textContent

# ready
# ~~
# If the question isn't empty
# and the @filled count is at
# least 2 we can submit
Module::isReady = !->
  @ready = /\S/.test(@entry.question!) && @filled! > 1

# Watch
# ~~
# Watches the inputs onkeyup
# and determines whether an option
# needs to be pushed or popped
Module::watch = (item) !->
  n = @filled!
  l = @entry.options.length

  switch true
  | n + 2 == l != 2
    @entry.pop!
  | n == l
    @entry.push!

  @isReady!

# Send
# ~~
# Sends a POST request to /q and
# redirect to the new entry
Module::send = (e)!->
  e.preventDefault()
  # Clone and pop @entry
  copy = {[k,v] for k,v of @entry}
  copy.options.pop!
  # Submit @entry
  EntryStore.post copy .then (res) !->
    Page "/q/#{res.slug}"
