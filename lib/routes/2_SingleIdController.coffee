
Routing.controllers.SingleIdController = Iron.RouteController.extend
  waitOn: -> Meteor.subscribe this.subscriptionName, {_id: this.params.id}
  data:   -> if this.ready() then this.collection().findOne this.params.id
