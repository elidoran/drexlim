# Local (client-only) collection
@Notices = new Meteor.Collection(null)

notice = (message, type) ->
  Notices.insert
    message: message
    type: type
    seen: false
    createdAt: new Date().getTime()

@Notify =
  info:    (message) -> notice message, 'info'
  success: (message) -> notice message, 'success'
  warning: (message) -> notice message, 'warning'
  error:   (message) -> notice message, 'danger'
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
