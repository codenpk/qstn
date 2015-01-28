# Sharer
# ~~
# Facebook sharer popup
exports.sharer = (e)->
  w = (window.innerWidth / 2)  - 250
  h = (window.innerHeight / 2) - 100
  window.open e.target.href, \fb, "
    width=500,
    height=300,
    top=#{h},
    left=#{w},
    toolbar=0,
    scrollbars=1,
    statusbar=0,
    menubar=0
  "
  false
