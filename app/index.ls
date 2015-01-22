require! {
  \mithril            : m
  \./config.ls        : config
  \./entries/index.ls : entries
  \./errors/index.ls  : errors
}

# Router push mode
m.route.mode = config.route.mode

# Register routes
m.route document.body, \/,
  * \/      : entries.index
    \/q/:id : entries.show
    \/:e... : errors.four
