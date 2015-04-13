
Template.userverify.onRendered ->
  token = FlowRouter.getParam 'id'
  if token?
    Accounts.verifyEmail token, ->
      Meteor.defer -> Notify.success 'Email Verified!'
      FlowRouter.go '/'
