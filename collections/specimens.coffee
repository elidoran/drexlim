# Specimen

@Specimens = new Meteor.Collection 'specimens'

Specimens.allow
  insert: -> true
  update: -> true
  remove: -> false


#Meteor.methods
