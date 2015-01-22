require! {
  \mithril          : m
  \../utils/ajax.ls : Ajax
}

Entry = {}

Entry.get = (id)->
  Ajax do
    * url: "/q/#id"
      method: \GET

Entry.post = (obj)->
  Ajax do
    * url: \/q/
      method: \POST
      data: obj

module.exports =
  Entry
