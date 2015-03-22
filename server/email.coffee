
Meteor.startup ->

  Accounts.config
    sendVerificationEmail: true


  # shortcut
  emails = Accounts.emailTemplates

  emails.siteName = 'Drexlim'
  emails.from = 'Eli Doran <eli+drexlim@elidoran.com>'

  # Enroll email
  #emails.enrollAccount.subject = (user) ->
  #  "Welcome to Drexlim #{user.profile.name}"
  #emails.enrollAccount.text = (user) ->
  #  "Hello #{user.profile.name}."

  # Reset Password email
  #emails.resetPassword.subject = (user) ->
  #  "Drexlim Password Reset for #{user.profile.name}"
  #emails.resetPassword.text = (user, url) ->
  #  "Reset your email here: #{url}"
  #emails.resetPassword.html = (user, url) ->
  #  "<p>#{user.profile.name}, let's get you a new password so you can login. Please, <a href='#{url}'>reset your password</a>.</p>"

  # Verify Email email
  #emails.verifyEmail.subject = (user) ->
  #  "Drexlim Email Verification for #{user.profile.name}"
  #emails.verifyEmail.text = (user, url) ->
  #  "Verify your email here: #{url}"
  #emails.verifyEmail.html = (user, url) ->
  #  "<p>#{user.profile.name}, please <a href='#{url}'>verify your email</a>.</p>"

  #Email.send
  #  from: 'eli+nexus@elidoran.com'
  #  to: 'eli+testing@elidoran.com'
  #  subject: 'Testing email send from MeteorJS'
  #  html: '<h1>Testing</h1><p>this is a test.</p>'


