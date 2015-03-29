
Tracker.autorun ->
  if not Meteor.userId()? # no longer logged in, send to login
    path = FlowRouter.current().path
    Session.set 'returnAfterLogin', path
    FlowRouter.go '/app/entry/user/login'

# # #
# Help with password reset sending user to a new route so they aren't stuck on the login
# # #

# key we're using in the Session to mark a login is happening from a password reset
resettingKey = 'Resetting Password Now'

# when this template is rendered, it means they just reset their password
Template._justResetPasswordDialog.onRendered ->
  Session.set resettingKey, true

# when a login occurs after the above template was rendered then send them to '/'
Accounts.onLogin ->
  if Session.equals resettingKey, true
    Session.set resettingKey, undefined
    FlowRouter.go '/'
