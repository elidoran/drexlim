
Template.userreset.events

  'submit #resetPasswordForm': (event, template) ->
    event.preventDefault()
    token = FlowRouter.current().params.id
    password = template.find('#password').value
    Accounts.resetPassword token, password, (err) ->
      if err?
        Notify.error 'Unable to reset your password. Please, retry.'
      else
        FlowRouter.go '/'
