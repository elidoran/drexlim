
publish = (name, options = {limit: 20, sort: {lastVisit: -1}}) ->

  Meteor.publish "recent-#{name}", ->

    Recents.find {userId: this.userId, from: name}, options

publish 'specimens'
publish 'storages'
publish 'collaborators'
publish 'members'
