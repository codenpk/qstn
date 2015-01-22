require! {
  \mithril            : m
  \../errors/index.ls : errors
}

# Title
# ~~
# Change title
exports.title = (v)!->
  x = document.title / ' | '
  document.title = document.title.replace x[0], v
