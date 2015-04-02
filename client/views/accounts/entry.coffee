

Tracker.autorun ->
  console.log 'UserID Tracker'
  if not Meteor.userId()? # no longer logged in, send to login
    path = FlowRouter.current().path
    console.log 'No UserID and path=', path
    if path # path is undefined when app first loads (first time this runs)
      Session.set 'returnAfterLogin', path
      whereTo = "/app/entry/user/login"
      console.log 'UserID Tracker whereTo=', whereTo
      Session.keys = {} # empty out session when logging out
      FlowRouter.go whereTo
