# Local (client-only) collection
@Errors = new Meteor.Collection(null)

@throwError = (message) ->
  Errors.insert { message: message }

@clearErrors = () ->
  Errors.remove {seen: true}
