require! {
  \mithril : m
}

# View
# ~~
# Module view
module.exports = (ctrl)->
  m \form.create,
    onsubmit: ctrl.ship.bind ctrl
    m \.input.large,
      contenteditable: true
      placeholder: 'What would you like to ask?'
      oninput: (e)!-> ctrl.entry.question do
        e.target.innerText
      onkeyup: ctrl.frozen.bind ctrl
      ctrl.entry.question!
    m \.options,
      ctrl.entry.options.map (v, i) ->
        m \.input.option,
          key: i
          contenteditable: true
          placeholder: "Option #{i+1}"
          oninput: (e)!-> v.option do
            e.target.innerText
          onkeyup: ctrl.watch.bind ctrl, v
          v.option!
    m \button,
      disabled: ctrl.froze
      \Ask
