'use strict'

require! \mithril : m
require! \../components/Link.ls

# View
# ~~
module.exports = (ctrl, body)->
  m \div,
    m \header.site-header,
      m \.content,
        m \h1.logo,
          Link do
            href: \/
            \qstz
        m \h5.motto,
          'Create and share polls \
           and get live results'
    m \main.site-main,
      m \.content, body
    m \footer.site-footer,
      m \.content,
        m \span,
          '\u00A9 2015 qstn ~ '
          m \a,
            * href: \//github.com/daryl/qstn
            \source
