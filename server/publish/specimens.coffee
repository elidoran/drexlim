
Meteor.publish 'singleSpecimen', (id) ->
  #console.log 'Publish singleSpecimen id=', id
  #Meteor._sleepForMs 2000
  #console.log 'Publish singleSpecimen done sleeping'
  if id? then Specimens.find {_id: id}

Meteor.publish 'specimens', (options={}) ->
  options = _.pick options, 'limit', 'sort'
  #console.log 'Publish Specimens options: ', options
  Specimens.find { }, options
