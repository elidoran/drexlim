
Meteor.startup ->

  Accounts.config
    sendVerificationEmail: true

  nameExistsFor = (user) -> user?.profile?.name?
  nameFor = (user) -> user.profile.name
  enrollUrl = (url) -> url.replace '/#/enroll-account', '/app/entry/user/enroll'
  resetUrl  = (url) -> url.replace '/#/reset-password', '/app/entry/user/reset'
  verifyUrl = (url) -> url.replace '/#/verify-email',   '/app/entry/user/verify'

  # shortcut
  emails = Accounts.emailTemplates

  emails.siteName = 'Drexlim'
  emails.from = 'Eli Doran <eli+drexlim@elidoran.com>'

  # Enroll email
  emails.enrollAccount.subject = (user) ->
    "Welcome to #{emails.siteName}#{' ' + nameFor user if nameExistsFor user}"
  emails.enrollAccount.text = (user, url) ->
    "Hello#{' ' + nameFor user if nameExistsFor user}.\n\nYour account is now ready for you. Begin here:\n\n#{enrollUrl url}"
  emails.enrollAccount.html = (user, url) ->
    "<p>Hello#{' ' + nameFor user if nameExistsFor user}. Your account is now ready for you.</p><p><a href='#{enrollUrl url}'>Begin here</a></p>"

  # Reset Password email
  emails.resetPassword.subject = (user) ->
    "#{emails.siteName} Password Reset#{' for ' + nameFor user if nameExistsFor user}"
  emails.resetPassword.text = (user, url) ->
    "Hello#{' ' + nameFor user if nameExistsFor user},\n\nClick link below to reset your password:\n\n#{resetUrl url}\n\nThank you.\n"
  emails.resetPassword.html = (user, url) ->
    "<p>Please, <a href='#{resetUrl url}'>click here</a> to <em>reset</em> your password.</p>"

  # Verify Email email
  emails.verifyEmail.subject = (user) ->
    "Drexlim Email Verification#{' for ' + nameFor user if nameExistsFor user}"
  emails.verifyEmail.text = (user, url) ->
    "Hello#{' ' + nameFor user if nameExistsFor user},\n\nClick link below to verify your password:\n\n#{verifyUrl url}\n\nThank you.\n"
  emails.verifyEmail.html = (user, url) ->
    "<p>Please, <a href='#{verifyUrl url}'>click here</a> to <em>verify</em> your password.</p>"

  #Email.send
  #  from: 'eli+nexus@elidoran.com'
  #  to: 'eli+testing@elidoran.com'
  #  subject: 'Testing email send from MeteorJS'
  #  html: '<h1>Testing</h1><p>this is a test.</p>'
