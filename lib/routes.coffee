
Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  #notFoundTemplate: 'notFound'
  
  waitOn: () ->
    [
    ]

Router.map () ->

  this.route 'biologs',
    path: '/'
    waitOn: -> Meteor.subscribe 'biologs'
    onRun:  -> 
      if Meteor.isClient
        Session.set 'biologsListNavClass', 'active'
        Session.set 'biologsSortNavClass', 'show'
    onStop: -> 
      if Meteor.isClient
        Session.set 'biologsListNavClass', ''
        Session.set 'biologsSortNavClass', 'disabled'

  this.route 'biologAdd',
    onRun:  ->
      if Meteor.isClient then Session.set 'biologsAddNavClass', 'active'
    onStop: ->
      if Meteor.isClient then Session.set 'biologsAddNavClass', ''
  
  this.route 'biologEdit',
    path: '/biologEdit/:_id' 
    waitOn: -> Meteor.subscribe 'biologs', this.params._id
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
    waitOn: -> Meteor.subscribe 'biologs', this.params._id
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

requireLogin = (pause) ->
  unless Meteor.user()
    if Meteor.loggingIn()
      this.render this.loadingTemplate
    else
      #this.render 'accessDenied'
      # store where they are so we can return after login?
      #Router.go 'entry'
      this.redirect 'entry'
    #pause()

Router.onBeforeAction requireLogin, { except: [ 'entry' ] }
Router.onBeforeAction -> clearNotices()
Router.onBeforeAction 'loading', {  }

