'use strict'

require! \mithril : m
require! \../errors/index.ls : errors

# Four
# ~~
# Render 404
exports.four = !->
  m.module do
    document.body
    errors.four
