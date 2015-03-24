console.log 'loading catchall file'

Router.route '/', ->
  console.log 'home route, redirecting ...'
  #console.log "what is our route? #{Router.current().url}"
  this.redirect '/specimens'
