#console.log 'loading catchall file'

Router.route '/',
  name: 'root'
  onBeforeAction: -> 
    console.log 'roooooooot...'
    this.next()
  #action: ->
  #  console.log "home route, #{this.url}, redirecting ..."
  #  this.redirect '/specimens'

