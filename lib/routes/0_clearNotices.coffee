console.log 'clear notices file'

RouteActions.before.clearNotices = ->
  clearNotices()
  this.next()
  
