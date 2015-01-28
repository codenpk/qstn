'use strict'

require! \mithril : m
require! \../utils/ajax.ls : Ajax

Entry = module.exports = {}

Entry.get = (id)->
  Ajax do
    url: "/q/#id"
    method: \GET

Entry.post = (obj)->
  Ajax do
    url: \/q/
    method: \POST
    data: obj
