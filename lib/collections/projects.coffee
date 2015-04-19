
@Projects = new Meteor.Collection 'projects'

Projects.allow
  insert: -> true
  update: -> true
  remove: -> false


Projects.after.insert Op.afterInsert 'projects'

Projects.after.update Op.afterUpdate 'projects'

Projects.attachSchema new SimpleSchema [
  Schema.CreatedAndUpdated
  name:
    type: String
    min:1
    max:500
    unique:true
    index:true
  code:
    type: String
    max:500
    optional:true
    unique:true
]


if Meteor.isServer

  Meteor.methods

    searchProjects: (query, options={limit:10,sort:['name','asc']}) ->
      options.limit = Math.min 10, Math.abs options.limit
      options.sort ?= sort:['name','asc']
      # need non-global with caret for indexed, which makes a 'prefix' index
      #regex = new RegExp "#{query}", 'gi'
      regex = new RegExp "^#{query}", 'i'
      cursor = Projects.find {name:{$regex:regex}}, options
      return cursor.fetch()
