Meteor.publish 'biologs', () -> 
  # for now, just show for the user
  Biologs.find { }
  # eventually, use role/allows to define which ones a user can see
  # this works along with the subscribe call to limit what's available
