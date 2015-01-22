require! {
  \mithril : m
}

Module = {}

# Controller
# ~~
# Module controller
Module.controller = (_m)!->
  c = new _m.controller
  @content = _m.view.bind @, c
  @onunload = !-> c.onunload?!

# View
# ~~
# Module view
Module.view = (ctrl)->
  m \div,
    m \header.site-header,
      m \.content,
        m \h1.logo,
          m \a,
            * config: m.route
              href: \/
            \qstn
        m \h5.motto,
          'Create and share polls \
           and get live results'
    m \main.site-main,
      m \.content, ctrl.content!
    m \footer.site-footer,
      m \.content,
        m \span,
          '\u00A9 2015 qstn ~ '
          m \a,
            * href: \//github.com/daryl/qstn
            \source

module.exports = (_m)->
  controller: ->
    new Module.controller _m
  view: Module.view
