# Local (client-only) collection
@Notices = new Meteor.Collection(null)

notice = (message, type) -> Notices.insert { message: message, type: type, seen: false }
@notifyInfo    = (message) -> notice message, 'info'
@notifySuccess = (message) -> notice message, 'success'
@notifyWarning = (message) -> notice message, 'warning'
@notifyError   = (message) -> notice message, 'danger'

@clearNotices = -> Notices.remove {seen: true}
