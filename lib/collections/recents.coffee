
@Recents = new Meteor.Collection 'recents',
  transform: (doc) ->
    doc.specimen = Specimens.findOne {_id: doc.refId}
    doc

Recents.allow
  insert: -> false
  update: -> false
  remove: -> false

Meteor.methods

  recentSpecimen: (id) ->
    recent = {refId:id, userId:this.userId, from:'specimens'}

    Recents.upsert recent, {$setOnInsert:recent,$set:lastVisited:new Date()}
