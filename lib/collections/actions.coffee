

# hold the names of our actions in the DB so admin can view them in the app
@Actions = new Meteor.Collection 'actions'

if Meteor.isServer
  console.log 'IS SERVER'
  Meteor.startup ->
    console.log 'startup calling action checkup'
    actionsInMemory = Action.actions()
    console.log 'actions in memory:'
    console.log actionsInMemory
    checked = {}
    Actions.find().forEach (action, index, cursor) ->
      name = action.name
      console.log "checking in db name: #{name}"
      checked[name] = true
      unless actionsInMemory.hasOwnProperty name
        console.log "removing action #{name}"
        Actions.remove action._id

    console.log 'checked...'
    console.log checked
    for name of actionsInMemory
      console.log "checking in memory name: #{name}"
      unless checked[name]
        console.log "inserting action #{name}"
        Actions.insert {name: name}
