
Routing.before.clearNotices = ->
  clearNotices()
  this.next()
