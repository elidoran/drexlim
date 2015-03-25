#console.log 'loading specimens routes'

recentDataRouteKey = 'recent.route.data'
storeRecentRoute = ->
  if Meteor.isClient
    recentUrl = this.url
    console.log "recent url = #{recentUrl}"
    Session.set recentDataRouteKey, recentUrl
  this.next()

SpecimensController = Iron.RouteController.extend
  layoutTemplate: 'dataLayout'
  onBeforeAction: storeRecentRoute

Router.route '/specimenAdd',
  controller: SpecimensController

Router.route '/specimensSearch',
  controller: SpecimensController

Router.route '/specimensRecent',
  controller: SpecimensController


SingleSpecimenController = Routing.controllers.SingleIdController.extend
  subscriptionName: 'singleSpecimen'
  collection: -> Specimens
  layoutTemplate: 'dataLayout'
  onBeforeAction: storeRecentRoute

Router.route '/view/:id',
  name: 'view'
  template: 'specimenView'
  controller: SingleSpecimenController

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
  layoutTemplate: 'dataLayout'
  onBeforeAction: storeRecentRoute
  controller: SpecimensListController


Router.route '/data',
  name: 'data'
  action: ->
    if Meteor.isClient
      # get most recent data route user went to
      recentRoute = (Session.get recentDataRouteKey) ? '/specimens'
      # redirect user to that route
      this.redirect recentRoute
    else
      this.next()

