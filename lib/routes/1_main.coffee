
Router.configure
  layoutTemplate: 'layout'
  #subscriptions: ->
  #  return Meteor.subscribe 'actions'
  onBeforeAction: () ->
    console.log "route: #{Router.current().url}"
    this.next()

Router.route '/entry',
  onRun: ->
    if Meteor.isClient
      Session.set 'entryMode', 'login'

Router.onBeforeAction Routing.before.requireLogin,
  except: [ 'entry' ]

Router.onBeforeAction Routing.before.clearNotices
