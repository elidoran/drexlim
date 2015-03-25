
# Used when displaying a list of items
# requires:
#   1. subscriptionName - string - name to pass to Meteor.subscribe
#   2. collection - function - returns the Meteor.Collection instance
# optional:
#   1. increment - number - amount displayed at first, amount added when clicked
#   2. sessionSortKey - string - key used to store sort option in Session
#   3. defaultSort - array of arrays of strings - sorting options
Routing.controllers.ListController = RouteController.extend

  # list shows this many at first, and adds this many more each time
  # TODO: use separate values for initial limit and additional increment
  increment: 1

  # default key used to store sorting info in session
  sessionSortKey: 'sortListBy'

  # default sorting
  defaultSort: [[ '_id', 'asc' ]]

  limit: ->
    if this.params?.limit?
      parseInt(this.params.limit)
    else
      this.increment

  findOptions: ->
    sortOption = (Session.get this.sessionSortkey) ? (this.defaultSort)
    { limit: this.limit(), sort: sortOption }

  waitOn: ->
    options = this.findOptions()
    Meteor.subscribe this.subscriptionName , options.limit, options.sort

  collectionFind: -> this.collection().find {}, this.findOptions()

  data: ->
    if this.ready()
      data = {}
      collectionFind = this.collectionFind()
      data[this.subscriptionName] = collectionFind
  
      limit = this.limit()
  
      # because we are telling the server to limit what we have to 'limit', we
      # can't know if there are *more* available. So, we always act like there is
      # more available if they gave us the limit we asked for
      if collectionFind.count() is limit
        data.nextPath = this.route.path { limit: limit + this.increment }
  
      return data
