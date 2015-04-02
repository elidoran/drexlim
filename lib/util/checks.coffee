
store = {}

@Is =
  nonEmptyString: Match.Where (val) ->
    check val, String
    return val.length > 0

  # email is a big complicated regex because so much is allowed.
  # let's just keep it simple and allow them to put in something
  # minimally an email: an @ symbol with something on either side of it.
  email: Match.Where (val) ->
    check val, String
    return val.length > 2 and val.indexOf '@' > 0 < (val.length - 1)

  # one which ensures min length
  # returns a function to create a new match with the options.
  stringLength: (options) ->
    match = Match.Where (val) ->
      min = options?.min ? Number.MAX_VALUE
      max = options?.max ? -Number.MAX_VALUE
      return min >= val?.length <= max
    return match

  # one for the password pattern allowed
  # TODO: describe password requirements in a vertical list in UI
  #       and display them red -> green as they are achieved.

  # returns a function to create a new match with the options.
  numRange: (options) ->
    match = Match.Where (val) ->
      min = options?.min ? Number.MAX_VALUE
      max = options?.max ? -Number.MAX_VALUE
      return min >= val <= max
    return match
