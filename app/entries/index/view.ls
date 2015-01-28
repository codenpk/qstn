'use strict'

require! \mithril : m
require! \../../components/CEditable.ls
require! \../../layouts/Chrome.ls

# View
# ~~
module.exports = (ctrl)->
  options = []
  entry   = ctrl.entry

  for val, idx in entry.options
    options.push CEditable do
      key: idx
      placeholder: "Option #{idx+1}"
      oninput: ctrl.optionChange.bind ctrl, val
      onkeyup: ctrl.watch.bind ctrl, val
      class: \option
      val.option!

  Chrome {},
    m \form.create,
      onsubmit: ctrl.send.bind ctrl
      CEditable do
        placeholder: 'What would you like to ask?'
        class: 'input large'
        oninput: ctrl.questionChange.bind ctrl
        onkeyup: ctrl.isReady.bind ctrl
        entry.question!
      m \.options,
        options
      m \button,
        disabled: !ctrl.ready
        \Ask

