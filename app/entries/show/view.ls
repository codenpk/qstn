'use strict'

require! \mithril : m

require! \../../utils/facebook.ls
require! \../../components/Radio.ls
require! \../../layouts/Chrome.ls

# View
# ~~
module.exports = (ctrl)->
  options = []
  entry   = ctrl.entry

  for val, idx in entry.options
    options.push m \.option,
      key: idx
      Radio do
        id: "o-#{idx}"
        checked: ctrl.selected == idx
        onchange: ctrl.change.bind ctrl, idx
        name: \option
        value: idx
      m \label.label,
        for: "o-#idx"
        val.option!
      m \.perc, "
        #{ctrl.perc val}%
        "
      m \.votes,
        val.votes!
      m \.bar,
        m \.pro,
          style: width: "
          #{ctrl.perc val}%
          "

  Chrome {},
    m \.show,
      m \header,
        m \h1, ctrl.entry.question!
      m \.options,
        options
      m \.social,
        m \p,
          'Share on '
          m \a.twitter,
            href: "
            //twitter.com/intent/
            tweet?text=#{ctrl.entry.question!}
            +http://qstn.co#{ctrl.entry.perma!}"
            \Twitter
          ' or '
          m \a.facebook,
            href: "
            //facebook.com/sharer/sharer.php?
            u=http://qstn.co#{ctrl.entry.perma!}"
            onclick: facebook.sharer
            \Facebook
        m \input,
          readonly: true
          value: "qstn.co#{ctrl.entry.perma!}"
          onclick: (e)-> e.target.select!

