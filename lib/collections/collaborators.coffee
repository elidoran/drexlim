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
    unique:true
    index:true
  orgId:
    type: Mongo.ObjectID
    optional: true
  orgName:
    type: String
    max: 500
    optional:true

if Meteor.isServer

  Meteor.methods

    searchCollaborators: (query, options={limit:10,sort:['name','asc']}) ->
      options.limit = Math.min 10, Math.abs options.limit
      options.sort ?= sort:['name','asc']
      # need non-global with caret for indexed, which makes a 'prefix' index
      #regex = new RegExp "#{query}", 'gi'
      regex = new RegExp "^#{query}", 'i'
      cursor = Collaborators.find {name:{$regex:regex}}, options
      return cursor.fetch()
