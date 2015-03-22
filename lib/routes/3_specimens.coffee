

###
# module to help define context routes like this
context.route 'specimens', 'dataLayout', [
  'add',
  'search',
  'recent'
]
###

recentDataRouteKey = 'recent.route.data'

storeRecentRoute = ->
  Session.set recentDataRouteKey, Router.current()?.url
  this.next()

Router.route '/specimens/add',
  name: 'specimens.add'
  template: 'specimens.add'
  layoutTemplate: 'dataLayout'
  onBeforeAction: [ Routing.before.requireLogin, storeRecentRoute ]

Router.route '/specimens/search',
  name: 'specimens.search'
  template: 'specimens.search'
  layoutTemplate: 'dataLayout'
  onBeforeAction: [ Routing.before.requireLogin, storeRecentRoute ]

Router.route '/specimens/recent',
  name: 'specimens.recent'
  template: 'specimens.recent'
  layoutTemplate: 'dataLayout'
  onBeforeAction: [ Routing.before.requireLogin, storeRecentRoute ]


# use ListController for Specimens List
SpecimensListController = Routing.controllers.ListController.extend
  subscriptionName: 'specimens'
  collection: -> return Specimens
  defaultSort: [[ 'logged.date', 'asc' ]]

Router.route '/specimens/:limit?',
  name: 'specimens.list'
  template: 'specimens.list'
  layoutTemplate: 'dataLayout'
  onBeforeAction: [ Routing.before.requireLogin, storeRecentRoute ]
  controller: SpecimensListController


Router.route 'data',
  onBeforeAction: ->
    # get most recent data route user went to
    recentRoute = (Session.get recentDataRouteKey) ? '/specimens'
    # redirect user to that route
    this.redirect recentRoute
