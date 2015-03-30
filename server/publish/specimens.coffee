
Meteor.publish 'singleSpecimen', (id) ->
  if id? then Specimens.find id

Meteor.publish 'specimens', (options={}) ->
  options = _.pick options, 'limit', 'sort'
  console.log 'Publish Specimens options: ', options
  Specimens.find { }, options
