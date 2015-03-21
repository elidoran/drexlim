
#Meteor.publish 'singleSpecimen', (id) ->
#  if id? then Biologs.find id

Meteor.publish 'specimens', (limit, sort) ->
  # for now, just show for the user
  options = {}
  if limit? then options.limit = limit
  if sort? then options.sort = sort
  Specimens.find { }, options
