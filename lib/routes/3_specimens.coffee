console.log 'loading specimens routes'

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
  recentUrl = Router.current()?.url
  console.log "recent url = #{recentUrl}"
  Session.set recentDataRouteKey, recentUrl
  this.next()

beforeActions = [ Routing.before.requireLogin, storeRecentRoute ]

SpecimensController = Iron.RouteController.extend
  layoutTemplate: 'dataLayout'
  onBeforeAction: beforeActions

Router.route '/specimenAdd',
  controller: SpecimensController

Router.route '/specimensSearch',
  controller: SpecimensController

Router.route '/specimensRecent',
  controller: SpecimensController


SingleSpecimenController = SpecimensController.extend
  waitOn: -> Meteor.subscribe 'singleSpecimen', {_id: this.params.id}
  data:   -> Specimens.findOne this.params.id

Router.route '/specimenView/:id',
  name: 'specimenView'
  controller: SingleSpecimenController

Router.route '/specimenEdit/:id',
  controller: SingleSpecimenController


# use ListController for Specimens List
SpecimensListController = Routing.controllers.ListController.extend
  subscriptionName: 'specimens'
  collection: -> Specimens
  defaultSort: [[ '_id', 'asc' ]]

Router.route '/specimens/:limit?',
  name: 'specimensList'
  #template: 'specimens.list'
  layoutTemplate: 'dataLayout'
  onBeforeAction: beforeActions
  controller: SpecimensListController


Router.route '/data',
  onBeforeAction: ->
    # get most recent data route user went to
    recentRoute = (Session.get recentDataRouteKey) ? '/specimens'
    # redirect user to that route
    this.redirect recentRoute
