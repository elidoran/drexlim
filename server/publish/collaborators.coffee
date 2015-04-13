
Meteor.publish 'singleCollaborators', (id) ->
  #console.log 'Publish singleCollaborators id=', id
  #Meteor._sleepForMs 2000
  #console.log 'Publish singleCollaborators done sleeping'
  if id? then Collaborators.find {_id: id}

Meteor.publish 'collaboratorss', (options={}) ->
  options = _.pick options, 'limit', 'sort'
  #console.log 'Publish Collaboratorss options: ', options
  Collaborators.find { }, options
