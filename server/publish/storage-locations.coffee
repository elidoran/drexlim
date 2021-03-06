
Meteor.publish 'singleStorage', (id) ->
  if id? then Storages.find id

Meteor.publish 'storages', (limit, sort) ->
  # for now, just show for the user
  options = {}
  if limit? then options.limit = limit
  if sort? then options.sort = sort
  Storages.find { }, options

ReactiveTable.publish 'storagesTable',
  -> if this?.userId? then Storages else []
  -> return {}  # selector function given to mongo
  # fields list? leave it null sends all, right?
