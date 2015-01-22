require! {
  \../../layouts/chrome.ls : chrome
}

Module =
  controller: require \./controller.ls
  view:       require \./view.ls

module.exports =
  chrome Module
