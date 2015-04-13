
Template.userenroll.events

  'submit #enrollPassword': (event, template) ->
    event.preventDefault()
    token = FlowRouter.current().params.id
    password = template.find('#password').value
    Accounts.resetPassword token, password, (err) ->
      if err?
        Notify.error 'Unable to set your new password. Please, retry.'
      else
        FlowRouter.go '/'
