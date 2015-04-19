
Meteor.publish 'singleSpecimen', (id) ->
  #console.log 'Publish singleSpecimen id=', id
  #Meteor._sleepForMs 2000
  #console.log 'Publish singleSpecimen done sleeping'
  if id? then Specimens.find {_id: id}

Meteor.publish 'specimens', (options={}) ->
  options = _.pick options, 'limit', 'sort'
  #console.log 'Publish Specimens options: ', options
  Specimens.find { }, options

ReactiveTable.publish 'specimensTable',
  -> if this?.userId? then Specimens else []
  -> return {}  # selector function given to mongo
  fields:
    _id:1
    'clinical.id':1
    'stock.id':1
    'b.id':1
    'gc.id':1
    dateCollected:1
    dateReceived:1
    'collab.name':1
    'loggedBy.name':1
    studyCode:1
    'stock.species':1
    'clinical.tissue':1
