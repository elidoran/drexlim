console.log 'require login file'

RouteActions.before.requireLogin = ->
  if Meteor.user()
      this.next()
  else
    if Meteor.loggingIn()
      this.render this.loadingTemplate
    else
      # store where they are so we can return after login?
      this.redirect '/entry'
