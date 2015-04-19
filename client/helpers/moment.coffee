
# add a date formatting helper
@formatDateWithMoment = (datetime, format) ->
  unless typeof format is 'string' then format = 'MM/DD/YYYY'
  if datetime? and moment?
    moment(datetime).format(format)
  else
    datetime

@parseDateWithMoment = (datetime, format) ->
  # use standard format for javscript to parse date inputs
  unless typeof format is 'string' then format = 'YYYY-MM-DD'
  if datetime? and moment?
    moment(datetime, format).toDate()
  else
    datetime

Template.registerHelper 'formatDate', formatDateWithMoment
