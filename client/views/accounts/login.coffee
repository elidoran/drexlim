
Template.userlogin.events

  'submit #loginForm': (event, template) ->

    event.preventDefault()

    email = Util.trim template.find('#email').value

    # TODO: verify valid email format
    unless email?.length > 0
      Notify.error 'You must specify an email'
      errors = true

    password = template.find('#password').value

    unless password?.length >= 8
      Notify.error 'You must specify a password at least 8 characters long.'
      errors = true

    if not errors?

      Notify.clear()

      Meteor.loginWithPassword email, password, (err) ->
        if err
          console.log 'login failure: ', err

          if err?.reason is 'Incorrect password'
            Notify.error 'Woopsy. Bad password. Try again?'

          else if err?.reason is 'User not found'
            Notify.error 'Who are you? I don\'t know that email'

          else
            Notify.error "Login failed: #{err.reason}"

        else
          # The user has been logged in.
          returnTo = (Session.get 'returnAfterLogin') ? '/'
          console.log "after login returning to: #{returnTo}"
          FlowRouter.go returnTo
