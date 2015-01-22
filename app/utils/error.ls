require! {
  \mithril            : m
  \../errors/index.ls : errors
}

# Four
# ~~
# Render 404
exports.four = !->
  m.module do
    document.body
    errors.four
