@Ops = new Meteor.Collection 'ops'

# all ops are created server side
Ops.allow
  insert: -> false
  update: -> false
  remove: -> false

Ops.attachSchema new SimpleSchema

  why: # why the op? basically, which kind of op... 'type' ?
    type:String
    allowedValues: [
      'insert', 'update', 'delete' # TODO: upsert?
    ]

  who: # _id of user the change was made by
    type:Object

  'who.refId':
    type: Meteor.ObjectID

  'who.name':
    type:String
    min:1
    max:200

  where: # name of collection the object is in
    type: 'String'
    allowedValues:[
      'specimens'
      'storages'
      'collaborators'
      'organizations'
      'projects'
      'users'
    ]

  what: # holds the _id of the object changed
    type: Object # can be the actual object, when it's an insert of an insert
    blackbox:true

  how: # how was it changed, key and value
    type: [Object]
    optional:true
    custom: ->
      unless this.field('why').value isnt 'update' or
        this.isSet or this.operator or this.value?
          return 'required'

  'how.$.key': # the property name which has a changed value
    type: String

  'how.$.value': # the new value they set
    #type: String # or... what if it can be different types?
    type:Object
    blackbox:true
    optional:true

  'how.$.when':
    type: Date
    optional:true # required for 2nd+ 'how' values.
    autoValue: -> new Date()

  when: # when the *initial* op occurred. for compound Ops, each key/value has a when
    type: Date
    autoValue: -> if this.isInsert then new Date else this.unset()
