
Template.header.helpers

  recentData: -> Session.get 'recent-data'

  userDisplayName: -> Meteor.user().profile.name

Template.header.events

  'click #userProfileLink': (event, template) ->
    event.preventDefault()
    FlowRouter.go '/app/user/User/Profile'

  'click #userSettingLink': (event, template) ->
    event.preventDefault()
    FlowRouter.go '/app/user/User/Setting'

  'click #userLogoutLink': (event, template) ->
    event.preventDefault()
    Meteor.logout (error) ->
      if error?
        console.log 'Logout error: ', error
        Notify.error "Please retry logout because: ", error.reason
      #else
        # do nothing, the tracker will do this. tho, now that we're handling
        # this, we could handle the redirect right here.
