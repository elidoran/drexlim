
Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  #subscriptions: ->
  #  return Meteor.subscribe 'actions'
  onBeforeAction: () ->
    console.log "route: #{this.url}"
    #console.log 'before every route... print \'this\' ...'
    #console.log this
    this.next()

Router.plugin 'dataNotFound',
  notFoundTemplate: 'notFound'

Router.route '/entry',
  onRun: ->
    if Meteor.isClient
      Session.set 'entryMode', 'login'

Router.onBeforeAction Routing.before.requireLogin,
  except: [ 'entry', 'view' ]

Router.onBeforeAction Routing.before.clearNotices
