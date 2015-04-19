
#publish = (name, collection, options = {limit: 10, sort: {lastVisit: -1}, fields:{_id:1,from:1,lastVisit:1}}) ->
publish = (name, collection, options = {limit: 10, sort: {lastVisit: -1}}) ->

  pubName = "recent-#{name}"

  Meteor.publish pubName, ->

    sub = this
    handles = {}

    unless (not options?.limit?) or 0 > options.limit <= 10
      options.limit = 10

    handle = Recents.find {userId: this.userId, from: name}, options
      .observeChanges
        added: (id, fields) ->
          cursor = collection.find {_id:fields.refId}
          handles[id] =
            Mongo.Collection._publishCursor cursor, sub, name
          sub.added 'recents', id, fields

        changed: (id, fields) -> sub.changed 'recents', id, fields

        removed: (id) ->
          handles[id].stop() if handles?[id]?
          sub.removed 'recents', id

    sub.ready()

    sub.onStop -> handle.stop()

publish 'specimens', Specimens
publish 'storages', Storages
publish 'collaborators', Collaborators
#publish 'members'#, Members
