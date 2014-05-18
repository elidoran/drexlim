
Template.notices.helpers
  notices: -> Notices.find()

Template.notice.rendered = ->
  notice = this.data
  if notice? then Meteor.defer ->
    Notices.update notice._id, { $set: {seen: true} }


