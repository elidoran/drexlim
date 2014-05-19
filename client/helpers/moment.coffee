
# add a date formatting helper
UI.registerHelper 'formatDate', (datetime, format = "MM/DD/YYYY") ->
  if moment? then moment(datetime).format(format) else datetime
