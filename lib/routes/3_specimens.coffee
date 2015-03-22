console.log '3 specimens routes file'

###
# module to help define context routes like this
context.route 'specimens', 'dataLayout', [
  'add',
  'search',
  'recent'
]
###

Router.route '/specimens/add',
  name: 'specimens.add'
  template: 'specimens.add'
  layoutTemplate: 'dataLayout'
  onBeforeAction: RouteActions.before.requireLogin

Router.route '/specimens/search',
  name: 'specimens.search'
  template: 'specimens.search'
  layoutTemplate: 'dataLayout'
  onBeforeAction: RouteActions.before.requireLogin

Router.route '/specimens/recent',
  name: 'specimens.recent'
  template: 'specimens.recent'
  layoutTemplate: 'dataLayout'
  onBeforeAction: RouteActions.before.requireLogin


# use ListController for Specimens List
SpecimensListController = Controllers.ListController.extend
  subscriptionName: 'specimens'
  collection: -> return Specimens
  defaultSort: [[ 'logged.date', 'asc' ]]

Router.route '/specimens/:limit?',
  name: 'specimens.list'
  template: 'specimens.list'
  layoutTemplate: 'dataLayout'
  onBeforeAction: RouteActions.before.requireLogin
  controller: SpecimensListController
