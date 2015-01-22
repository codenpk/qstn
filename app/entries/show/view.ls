require! {
  \mithril                 : m
  \../../utils/facebook.ls : facebook
}

# View
# ~~
# Module view
module.exports = (ctrl)->
  m \.show,
    m \header,
      m \h1, ctrl.entry.question!
    m \.options,
      ctrl.entry.options.map (o, i)->
        m \.option,
          m \.radio,
            m \input,
              type: \radio
              checked: ctrl.selected == i
              onchange: ctrl.change.bind ctrl, i
              name: \option
              value: i
              id: "o-#i"
            m \label,
              for: "o-#i"
          m \label.label,
            for: "o-#i"
            o.option!
          m \.perc, "
            #{ctrl.perc o}%
            "
          m \.votes,
            o.votes!
          m \.bar,
            m \.pro,
              style: width: "
              #{ctrl.perc o}%
              "
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

