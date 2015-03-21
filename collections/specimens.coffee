# Specimen

@Specimens = new Meteor.Collection 'specimens'

Specimens.allow
  insert: -> true
  update: -> false
  remove: -> false

#Meteor.methods
