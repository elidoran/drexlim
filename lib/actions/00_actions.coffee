
# hold the action functions in the app's namespace to reference and run them
storedActions = {}
storedCount = 0

# make a global Action object to store actions registered with it
@Action =
  add: (name, action) ->
    if name? and action?
      action.name = name # this is a side effect. that's bad ;)
      unless storedActions.hasOwnProperty name
        storedActions[name] = action
        storedCount += 1
      else
        console.error "Already have an Action named: #{name}"

  get: (name) -> return storedActions[name]

  count: -> return storedCount

  actions: -> return storedActions
