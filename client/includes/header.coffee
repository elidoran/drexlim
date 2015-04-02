
defaultRecent =
  data: '/app/data/Specimen/Recent'
  people: '/app/people/Collaborator/Recent'

Template.header.helpers

  recent: (sidebar) ->
    (Session.get "recent-#{sidebar}") ? defaultRecent[sidebar]

  sidebar: (name) ->
    if name is FlowRouter.getParam 'sidebar'
      'active'
      
  userDisplayName: -> Meteor.user().profile.name

Template.header.events

  'click #userLogoutLink': (event, template) ->
    event.preventDefault()
    Meteor.logout (error) ->
      if error?
        console.log 'Logout error: ', error
        Notify.error "Please retry logout because: ", error.reason
      #else
        # do nothing, the tracker will do this. tho, now that we're handling
        # this, we could handle the redirect right here.
