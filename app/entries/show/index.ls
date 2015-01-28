Module =
  controller: require \./controller.ls
  view:       require \./view.ls

module.exports = (ctx) ->
  controller: ->
    new Module.controller ctx
  view: Module.view
