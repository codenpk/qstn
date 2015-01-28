'use strict'

require! \mithril : m

Option = (obj) !->
  @option = m.prop obj.option or ''
  @votes  = m.prop obj.votes or 0

Entry = module.exports = (obj) !->
  @slug = obj.slug
  @question = m.prop obj.question
  @options = obj.options.map (v) ->
    new Option v

Entry::perma = -> "/q/#{@slug}"

Entry::pop = !-> @options.pop!

Entry::push = !->
  @options.push do
    new Option do
      * option: ''
