
Routing.before.requireLogin = ->
  console.log 'require login...'
  if Meteor.userId()?
    console.log 'has userId so... logged in already'
    this.next()
  else
    # store where they are so we can return after login?
    if Meteor.isClient?
      url = this.url
      console.log "requireLogin checking route: #{url}"
      Session.set 'loginEntryFrom', url
    this.redirect '/entry'
