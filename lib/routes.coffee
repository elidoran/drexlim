
Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  #notFoundTemplate: 'notFound'
  
  waitOn: () ->
    [
      Meteor.subscribe 'biologs'
    ]

Router.map () ->

  this.route 'biologs',       { path: '/' }
  this.route 'biologSubmit',  {}
  this.route 'biologEdit',
    path: '/biologEdit/:_id' 
    data: -> Biologs.findOne this.params._id
  this.route 'biologView',
    path: '/biologView/:_id' 
    data: -> Biologs.findOne this.params._id

  
#  this.route 'login', { path: 'login' }

#  this.route 'user'

requireLogin = (pause) ->
  unless Meteor.user()
    if Meteor.loggingIn()
      this.render this.loadingTemplate
    else
      this.render 'accessDenied'
    pause()

Router.onBeforeAction requireLogin, {  }
Router.onBeforeAction () -> clearErrors()
Router.onBeforeAction 'loading', {  }

