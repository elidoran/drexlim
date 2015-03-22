
Router.configure
  layoutTemplate: 'layout'

Router.route '/', ->
  this.redirect '/specimens'

Router.route '/entry',
  onRun: ->
    if Meteor.isClient
      Session.set 'entryMode', 'login'

Router.onBeforeAction RouteActions.before.requireLogin,
  except: [ 'entry' ]

Router.onBeforeAction RouteActions.before.clearNotices
