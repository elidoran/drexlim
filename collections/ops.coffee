@Ops = new Meteor.Collection 'ops'

# all ops are created server side
Ops.allow
  insert: -> false
  update: -> false
  remove: -> false

#Meteor.methods
