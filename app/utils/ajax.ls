require! {
  \mithril : m
}

# Config
# ~~
# XHR config
config = (xhr)!->
  xhr.setRequestHeader do
    \X-Requested-With
    \XMLHttpRequest

# Before
# ~~
# Before request
before = !->
  document.body.setAttribute \loading, ''

# After
# ~~
# After request
after = (value)->
  document.body.removeAttribute \loading
  value

module.exports = (args)->
  before!
  args.config = config
  m.request args .then do
    after, after
