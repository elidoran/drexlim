
Template.entry.helpers
  entryMode:    -> Session.get 'entryMode' ? 'login'
  loginClass:   -> if Session.equals 'entryMode', 'login'  then 'active' else ''
  createClass:  -> if Session.equals 'entryMode', 'create' then 'active' else ''
  forgotClass:  -> if Session.equals 'entryMode', 'forgot' then 'active' else ''
  createActive: -> Session.equals 'entryMode', 'create'
  loginOrCreateActive: ->
    (Session.equals 'entryMode', 'login') or (Session.equals 'entryMode', 'create')

  entryButtonText: ->
    switch Session.get 'entryMode'
      when 'login' then 'Login'
      when 'create' then 'Add Account'
      when 'forgot' then 'Send Reset Email'
      else 'login'

Template.entry.events

  # shouldn't need the click event, the submit event should do both
  #'click #entryButton': (e, t) -> enter e, t
  'submit #entryForm' : (e, t) -> enter e, t
  'click #entryLogin' : (e, t) -> Session.set 'entryMode', 'login'
  'click #entryCreate': (e, t) -> Session.set 'entryMode', 'create'
  'click #entryForgot': (e, t) -> Session.set 'entryMode', 'forgot'

enter = (e, t) ->

  e.preventDefault()

  # we always need the email, so, get it and check it
  entryInfo =
    email: trimInput t.find('#email').value

  unless entryInfo?.email?.length > 0
    notifyError 'You must specify an email.'

  # get the entry mode
  entryMode = Session.get 'entryMode'

  # if it's *not* 'forgot password' mode, then we need more
  if entryMode isnt 'forgot'

    # get the password
    entryInfo.password = t.find('#password').value

    unless entryInfo?.password?.length >= 8
      notifyError 'You must specify a password. It must be at least 8 characters long.'

    # if it's *not* 'login' then it must be create, and we need more info
    if entryMode isnt 'login'

      # get the name
      entryInfo.profile =
        name: trimInput t.find('#name').value

      unless entryInfo?.profile?.name?.length > 0
        notifyError 'You must specify a Name.'

      # we have everything we need to create the new user
      createUser entryInfo

    else # it is 'login' mode
      loginUser entryInfo

  else # it is 'forgot' mode, so, send reset email
    Accounts.forgotPassword entryInfo, (err) ->
      if err then notifyError err
      else notifyError 'Reset email sent'

  # don't let it send the form
  return false

loginUser = (info) ->

    Meteor.loginWithPassword info.email, info.password, (err) ->
      if err
        # The user might not have been found, or their password
        # could be incorrect. Inform the user that their
        # login attempt has failed.
        console.log 'login failed...'
        console.log "err = #{err}"
        console.log "err = #{_.pairs err}"
        notifyError 'Login failed'
      else
        # The user has been logged in.
        Router.go '/'
       return false;

createUser = (info) ->

  Accounts.createUser info, (err) ->
    if err
      # Inform the user that account creation failed
      console.log 'creation failed'
      console.log "err = #{err}"
      console.log "err = #{_.pairs err}"
    else
      # Success. Account has been created and the user
      # has logged in successfully.
      Router.go '/'

trimInput = (val) ->
  if val? then val.replace /^\s*|\s*$/g, "" else val
