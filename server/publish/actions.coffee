
Meteor.publish 'singleAction', (id) ->
  if id? then Specimens.find id

Meteor.publish 'actions', (limit, sort) ->
  # for now, just show for the user
  options = {}
  if limit? then options.limit = limit
  if sort? then options.sort = sort
  Specimens.find { }, options
