
Router.configure
  layoutTemplate: 'layout'

Router.route '/', ->
  this.redirect '/specimens'

Router.route '/entry',
  onRun: ->
    if Meteor.isClient
      Session.set 'entryMode', 'login'

Router.onBeforeAction Routing.before.requireLogin,
  except: [ 'entry' ]

Router.onBeforeAction Routing.before.clearNotices
