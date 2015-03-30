
@Recents = new Meteor.Collection 'recents'

Recents.allow
  insert: -> true
  update: -> true
  remove: -> true
