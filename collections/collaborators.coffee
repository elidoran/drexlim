# Collaborators

@Collaborators = new Mongo.Collection 'collaborators'

Collaborators.allow
  insert: -> true
  update: -> true
  remove: -> false


Collaborators.attachSchema new SimpleSchema
  name:
    type: String
    max: 500
  orgId:
    type: Mongo.ObjectID
    optional: true
  orgName:
    type: String
    max: 500
    optional:true

Meteor.methods

  something: () ->
