@Ops = new Meteor.Collection 'ops'

# all ops are created server side
Ops.allow
  insert: -> true
  update: -> false
  remove: -> false

#Ops.deny
#  update: (userId, biologData, fieldNames) ->
#    # may not edit the HS# field:
#    (_.without(fieldNames, 'hs').length > 0)
#    # check permissions to see what the user is allowed to do
#    # based on whether they own it, what they're changing, ...
#    #false
    
Meteor.methods

  bleh: () ->
    
