
# # #
# Help with password reset sending user to a new route so they aren't stuck on the login
# # #

# key we're using in the Session to mark a login is happening from a password reset
resettingKey = 'Resetting Password Now'

# when this template is rendered, it means they just reset their password
Template._justResetPasswordDialog.onRendered ->
  console.log 'just reset password dialog rendered'
  Session.set resettingKey, true 

# when a login occurs after the above template was rendered then send them to '/'
Accounts.onLogin ->
  console.log 'user logged in now'
  console.log "user -> #{Meteor.user().profile.name}"
  if Session.equals resettingKey, true
    console.log 'login was after password reset, forwarding them...'
    Session.set resettingKey, undefined
    Router.go '/'

