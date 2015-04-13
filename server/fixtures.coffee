
addUsers = ->
  console.log 'adding in users...'
  users = [
    {
      enroll: false
      #email: 'carol.hope@drexelmed.edu'
      email: 'eli+carol@elidoran.com'
      password: 'testingc'
      profile:
        name: 'Carol Hope'
    }
    {
      enroll: false
      #email: 'josh@drexelmed.edu'
      email: 'eli+josh@elidoran.com'
      password: 'testingj'
      profile:
        name: 'Josh Earl'
    }
    {
      enroll: true
      email: 'eli+drexlim@elidoran.com'
      password: 'testing1'
      profile:
        name: 'Eli Doran'
    }
  ]

  for user in users

    userId = Accounts.createUser user
    if user.enroll then Accounts.sendEnrollmentEmail userId

  console.log 'users added'

importData = ->
  console.log 'fillin...'

  headers = [
    'S#'
    'B#'
    'BS#'
    'GC#'
    'StudyCode'
    'Tissue'
    'Subject'
    'X - H'
    'X - I'
    'X - J'
    'X - K'
    'X - L'
    'X - M'
    'X - N'
    'X - O'
    'Date collected'
    'Date received'
    'X - Tissue Banking'
    'Species'
    'Collaborator'
    'Logged by'
    'Storage Location'
    'Shelf'
    'Rack'
    'Box'
    'Cell'
    'Comments'
  ]

  console.log 'headers: ', headers

  csv = Meteor.npmRequire 'fast-csv'

  lineCount = 0
  line = (data) ->
    lineCount++
    if lineCount is 1
      console.log "[#{headers[index]}] = [#{value}]" for value,index in data

      specimen =
        _id = data[0] # S#



  finish = ->
    console.log "lines = #{lineCount}"

  try
    file = "#{process.cwd()}/../../../../../server/import.csv"
    console.log 'file path: ',file
    csv
    .fromPath file#'./import.csv'
    .on 'data', line
    .on 'end',  finish
  catch e
    console.log 'caught exception using csv'
    console.log "#{key} =  #{value}" for own key,value of e
    console.log e
    console.log e.reason

  console.log 'finished fillin'

Meteor.startup ->

  if Meteor.users.find().count() is 0
    addUsers()

  if Specimens.find().count() is 0
    importData()
