
Meteor.publish 'singleBiolog', (id) ->
  if id? then Biologs.find id

Meteor.publish 'biologs', (limit, sort) -> 
  # for now, just show for the user
  options = {}
  if limit? then options.limit = limit
  if sort? then options.sort = sort
  Biologs.find { }, options
  
  # eventually, use role/allows to define which ones a user can see
  # this works along with the subscribe call to limit what's available
