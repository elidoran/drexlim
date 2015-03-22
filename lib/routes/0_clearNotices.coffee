
RouteActions.before.clearNotices = ->
  clearNotices()
  this.next()
