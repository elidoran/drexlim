
requireLogin = () ->
  if Meteor.user()
      this.next()
  else
    if Meteor.loggingIn()
      this.render this.loadingTemplate
    else
      # store where they are so we can return after login?
      this.redirect 'entry'

BiologListController = RouteController.extend({

  template: 'biologList'
  layoutTemplate: 'dataLayout'

  increment: 1

  limit: ->
    if this.params?.limit?
      parseInt(this.params.limit)
    else
      this.increment

  findOptions: ->
    # can i use Session here??
    sortOption = (Session.get 'sortBiologList') ? ([[ 'logged.date', 'asc']])
    { limit: this.limit(), sort: sortOption }

  waitOn: ->
    options = this.findOptions()
    Meteor.subscribe 'biologs' , options.limit, options.sort

  biologs: -> Biologs.find {}, this.findOptions()

  data: ->
    data =
      biologs: this.biologs()

    limit = this.limit()

    # because we are telling the server to limit what we have to 'limit', we
    # can't know if there are *more* available. So, we always act like there is
    # more available if they gave us the limit we asked for
    if data.biologs.count() is limit
      data.nextPath = this.route.path { limit: limit + this.increment }

    return data
})

Router.onBeforeAction requireLogin, { except: [ 'entry' ] }
Router.onBeforeAction ->
  clearNotices()
  this.next()

Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  #notFoundTemplate: 'notFound'

  waitOn: ->
    [
    ]

Router.map ->

  this.route 'biologAdd',
    disableProgress: true
    onRun:  ->
      if Meteor.isClient then Session.set 'biologsAddNavClass', 'active'
    onStop: ->
      if Meteor.isClient then Session.set 'biologsAddNavClass', ''

  this.route 'biologEdit',
    path: '/biologEdit/:_id'
    waitOn: -> Meteor.subscribe 'singleBiolog', this.params._id
    data: -> Biologs.findOne this.params._id
    onRun:  ->
      if Meteor.isClient
        Session.set 'biologsEditNavClass', 'show active'
        Session.set 'biologsViewNavClass', 'show'
    onStop: ->
      if Meteor.isClient
        Session.set 'biologsEditNavClass', 'disabled'
        Session.set 'biologsViewNavClass', 'disabled'

  this.route 'biologView',
    path: '/biologView/:_id'
    waitOn: -> Meteor.subscribe 'singleBiolog', this.params._id
    data: -> Biologs.findOne this.params._id
    onRun:  ->
      if Meteor.isClient
        Session.set 'biologsViewNavClass', 'show active'
        Session.set 'biologsEditNavClass', 'show'
    onStop: ->
      if Meteor.isClient
        Session.set 'biologsViewNavClass', 'disabled'
        Session.set 'biologsEditNavClass', 'disabled'

  this.route 'entry',
    onRun: ->
      if Meteor.isClient
        Session.set 'entryMode', 'login'

  # listed last because it basically matches everything
  this.route 'biologList',
    path: '/:limit?'
    controller: BiologListController
    onRun:  ->
      if Meteor.isClient
        Session.set 'biologsListNavClass', 'active'
        Session.set 'biologsSortNavClass', 'show'
    onStop: ->
      if Meteor.isClient
        Session.set 'biologsListNavClass', ''
        Session.set 'biologsSortNavClass', 'disabled'
