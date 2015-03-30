# Storage Locations

@Storages = new Meteor.Collection 'storages'

Storages.allow
  insert: -> true
  update: -> true
  remove: -> true

newStorage = () ->
  console.log 'insert storage'

updateStorage = () ->
  console.log 'update storage'

deleteStorage = () ->
  console.log 'delete storage'

Meteor.methods

  newStorage: newStorage
  updateStorage: updateStorage
  deleteStorage: deleteStorage
