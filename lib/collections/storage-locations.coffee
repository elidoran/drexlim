# Storage Locations

@Storages = new Meteor.Collection 'storages',
  transform: (doc) ->
    # add the name() function so we can call it if we want it...
    doc.getName = () ->
      unless doc?.name?
        doc.name = "#{doc.room}-#{doc.type}-#{doc.rack}-#{doc.shelf}-#{doc.box}-#{doc.cell}"
      doc.name
    return doc

Storages.allow
  insert: -> true
  update: -> true
  remove: -> false

Storages.after.insert Op.afterInsert 'storages'

Storages.after.update Op.afterUpdate 'storages'

Storages.attachSchema new SimpleSchema [
  Schema.CreatedAndUpdated
  #name:
  #  type:String
  #  max:100
  specimenId:
    type:Meteor.ObjectID
    unique:true
  room:
    type:String
    max:100
    optional:true
  rack:
    type:String
    max:100
    optional:true
  shelf:
    type:String
    max:100
    optional:true
  box:
    type:String
    max:100
    optional:true
  cell:
    type:String
    max:100
    optional:true
  type:
    type:String
    allowedValues: [ 'Fridge', 'Freezer' ]
    optional:true
  #temp: # TODO: temperature of storage?
  #  type:String
  #  optional:true
  storedBy:
    type:Object
    optional:true
  'storedBy.refId':
    type:Meteor.ObjectID
    optional:true
  'storedBy.name':
    type:String
    max:200
    optional:true
  #TODO: delete this one once they've adapted it into the other fields
  location:
    type:String
    max:500
    optional:true
]



if Meteor.isServer

  Meteor.methods

    searchStorages: (query, options={limit:10,sort:['name','asc']}) ->
      options.limit = Math.min 10, Math.abs options.limit
      options.sort ?= sort:['name','asc']
      # need non-global with caret for indexed, which makes a 'prefix' index
      #regex = new RegExp "#{query}", 'gi'
      regex = new RegExp "^#{query}", 'i'
      cursor = Storages.find {name:{$regex:regex}}, options
      return cursor.fetch()
