
# Clear all *seen* notices when the route changes
FlowRouter.middleware (path, next) ->
  Notify.clear()
  next()

entryPathPrefix = /^\/app\/entry/i
requireLogin = (path, next) ->
  if not (entryPathPrefix.test(path) or Meteor.userId()?)
    # record where they were heading to send them there after login
    Session.set 'returnAfterLogin', path
    whereTo = '/app/entry/user/login'
  next whereTo

# ###### Main Route ###### #
# specifies:
#  1. the overall layout to use
#  2. the sidebar content, which is a context menu for a header item
#  3. the menu item group in the sidebar
#  4. the menu item in the sidebar, this is the specific view to show in main
#  5. [optional] the ID of the object we are looking at
#
# TODO:
#   consider more complicated URLs, can we fit them in here?
#   make another route with that style...
#   What other routes do we want? search params?
# ###### ########## ####### #
FlowRouter.route '/:layout/:sidebar/:menu/:item/:id?',
  middlewares :[
    requireLogin
  ]

  action: (params) ->
    # remember this path for the specific sidebar value
    path = params['0'] # '0' === FlowRouter.current().path
    if path
      Session.set "recent-#{params.sidebar}", path

      # render the layout and templates according to the params
      FlowLayout.render params.layout,
        sidebar: params.sidebar
        main:    params.menu + params.item

FlowRouter.route '/',
  middlewares: [ (p, next) -> next '/app/data/Specimen/Recent' ]
  action: ->

# TODO: test this
FlowRouter.notfound =
  middlewares: [requireLogin]
  action: -> Notify.error 'Unable to find that...'
