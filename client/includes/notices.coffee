# Local (client-only) collection
@Notices = new Meteor.Collection(null)

addNotice = (message, type) ->
  Notices.insert
    message: message
    type: type
    seen: false
    createdAt: new Date().getTime()

@Notify =
  info:    (message) -> addNotice message, 'info'
  success: (message) -> addNotice message, 'success'
  warning: (message) -> addNotice message, 'warning'
  error:   (message) -> addNotice message, 'danger'
  clear:   -> Notices.remove {seen: true}

Template.notices.helpers
  notices: -> Notices.find {}, {limit: 3, sort: ['createdAt', 'desc']}

Template.notice.onRendered ->
  notice = this.data
  if notice? then Meteor.defer ->
    Notices.update notice._id, { $set: {seen: true} }

Template.notice.events

  'click .alert': (event, template) ->
    Notices.remove template.data._id
