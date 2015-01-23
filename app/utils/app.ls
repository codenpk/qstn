require! {
  \mithril : m
}

# Title
# ~~
# Change title
exports.title = (v)!->
  x = document.title / ' | '
  document.title = document.title.replace x[0], v
