
@Is =
  nonEmptyString: Match.Where (val) ->
    check val, String
    return val.length > 0

# one which ensures string length

# one which verifies email pattern

# one for the password pattern allowed
