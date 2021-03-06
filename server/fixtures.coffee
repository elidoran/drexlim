
datePattern = /\d{1,2}\/\d{1,2}\/\d{4}/
toDate = (dateString) ->
  #console.log "toDate #{dateString}"
  if dateString? and datePattern.test dateString
    return moment(dateString, 'MM-DD-YYYY').toDate()
  else
    return null

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
    'S#'                  # 0
    'B#'                  # 1
    'BS#'                 # 2
    'GC#'                 # 3
    'StudyCode'           # 4
    'Tissue'              # 5
    'Subject'             # 6
    'X - H'               # 7
    'Location (Clinical)' # 8
    'Indication'          # 9
    'Surgeon'             # 10
    'X - L - first name'  # 11
    'X - M - middle name' # 12
    'X - N - DOB'         # 13
    'X - O - Sex'         # 14
    'Date collected'      # 15
    'Date received'       # 16
    'X - Tissue Banking'  # 17
    'Species'             # 18
    'Collaborator'        # 19
    'Logged by'           # 20
    'Storage Location'    # 21
    'Shelf'               # 22
    'Rack'                # 23
    'Box'                 # 24
    'Cell'                # 25
    'Comments'            # 26
  ]

  #console.log 'headers: ', headers

  csv = Meteor.npmRequire 'fast-csv'

  created =
    specimenCount:0
    collabCount: 0
    collab: {}
    projectCount: 0
    project: {}
    storage: {}
    storageCount: 0

  roomPattern = /(\d{4})/
  transportPattern = /Transported.+by (\w+)[,\s]*/
  lineCount = 0
  line = (data) ->
    specimenId = data[0]
    lineCount++
    if lineCount > -1
      #console.log "[#{headers[index]}] = [#{value}]" for value,index in data

      collab = do (collabName = data[19]) ->
        if collabName?.length > 0
          collab = created.collab?[collabName]
          #collab = Collaborators.findOne name:collabName
          unless collab?
            count = 3
            while count-- >= 0
              try
                id = Collaborators.direct.insert name:collabName
                created.collabCount++
                collab = created.collab[collabName] =
                  refId: id
                  name: collabName
              catch e
                collab = Collaborators.direct.findOne name:collabName
                unless collab?
                  collab = created.collab[collabName]
                else
                  collab =
                    refId: collab._id
                    name: collabName
          return collab

      project = do (studyCode = data[4]) ->
        if studyCode? and studyCode.length > 0
          project = created.project?[studyCode]
          #project = Projects.findOne {code:studyCode}
          unless project?
            count = 3
            while count-- >= 0
              try
                id = Projects.direct.insert {name:studyCode, code:studyCode}
                created.projectCount++
                project = created.project[studyCode] =
                  refId: id
                  name: studyCode
              catch e
                project = Projects.direct.findOne {name:studyCode, code:studyCode}
                unless project?
                  project = created.project[studyCode]
                else
                  project =
                    refId: project._id
                    name: studyCode
          return project

      stored = do (location=data[21], shelf=data[22], rack=data[23], box=data[24], cell=data[25]) ->
        if location?.length > 0
          storage = created.storage?[specimenId]
          unless storage?
            count = 3
            match = roomPattern.exec location
            room = match?[1]
            storage = location:location, specimenId:specimenId
            storage.room = room if room?
            if shelf? then storage.shelf = shelf
            if rack? then storage.rack = rack
            if box? then storage.box = box
            if cell? then storage.cell = cell
            if location.indexOf 'reezer' > -1 then storage.type = 'Freezer'
            if location.indexOf 'refrigerator' then storage.type = 'Fridge'
            while count-- >= 0
              try
                id = Storages.direct.insert storage
                created.storageCount++
                storage = created.storage[specimenId] =
                  refId: id
                  name: location
              catch e
                storage = Storages.direct.findOne specimenId:specimenId
                unless storage?
                  storage = created.storage[specimenId]
                else
                  storage =
                    refId:storage._id
                    name:location
          return storage


      # already loaded Carol so... it's always her user ;)
      logger = do (loggerName = data[20]) ->
        user = Meteor.users.findOne {'profile.name':loggerName}
        unless user?
          # can't create new user without knowing their email...
          console.log 'Unknown logger: ',loggerName
        else
          return refId:user._id, name:user.profile.name

      # if comment says "by <name>" then they are the 'storedBy' value
      comment = data[26] ? ''
      storedByName = do (comment) ->
        if comment?.length > 0
          match = transportPattern.exec comment
          theName = match?[1]
        return theName

      specimen =
        _id: specimenId
        accession: ''
        #studyCode: data[4]
        tags:['imported']
        note: comment # TODO: if 'Transported...by...' then don't put in notes?
        # storage:
        #   display: data[21]
        clinical:
          #id:'?'
          tissue:data[5]
          subject:data[6]
          indication:data[9]
          surgeon:data[10]
          dob:toDate data[13]
          place:'?'
          storage:
            #id: no id... no storage locations yet
            display:'No storage information'
        stock:
          id:data[2]
          species:data[18]
          strainId: '?'
          phenotype: '?'
          passage:[]
          dateFrozen:null
          storedBy:
            name: storedByName
          storage:
            #id: no id... no storage locations yet
            display:'No storage information'
        gc:
          id: data[3]
          #madeBy:
          #  id:
          #  name:
          #genotype:
          #plasmid:
          #resistance: #array?
          #concentration
          #storage:
          #  id
          #  display
        b:
          id: data[1]
        #   fromStockId:
        #   dateExtracted:
        #   extracted:
        #     date:
        #     by:
        #       id:
        #       name:
        #   storage:
        #     id:
        #     display:
        #   concentration:
        #   volume:

      if collab?  then specimen.collab   = collab
      else if data?[19].length > 0
        console.log 'Collaborator exists, but, *NO* Collaborator set...:',data[19]

      if logger?  then specimen.loggedBy = logger

      if project? then specimen.project  = project
      else if data?[4].length > 0
        console.log 'StudyCode exists, but, *NO* Project set...:',data[4]

      date = toDate data[15]
      if date?
        specimen.dateCollected = date
      else if data?[15]? and data[15].length > 0
        unless specimen?.imported? then specimen.imported = {}
        specimen.imported.dateCollectedString = data[15]

      date = toDate data[16]
      if date?
        specimen.dateReceived = date
      else if data?[16]? and data[16].length > 0
        unless specimen?.imported? then specimen.imported = {}
        specimen.imported.dateReceivedString = data[16]

      if specimen._id is '40366'
        specimen.dateCollected = toDate '06/04/2014'
        unless specimen?.imported? then specimen.imported = {}
        specimen.imported = dateCollected2:toDate '09/24/2014'

      #console.log 'New Specimen:\n  ',specimen
      try
        result = Specimens.upsert {_id:specimen._id}, {$set: specimen}, {multi:false}
        created.specimenCount++
        if result?.numberAffected isnt 1 and not result.insertedId?
          console.log 'Problem with specimen:',specimen
      catch e
        console.log 'error upserting specimen...',e.reason
        console.log e

  finish = ->
    console.log "lines = #{lineCount} specs+#{created.specimenCount} collab+#{created.collabCount} projects+#{created.projectCount} storages+#{created.storageCount}"

  try
    file = "#{process.cwd()}/../../../../../server/import.csv"
    #console.log 'file path: ',file
    csv
    .fromPath file#'./import.csv'
    .on 'data', Meteor.bindEnvironment line
    .on 'end',  Meteor.bindEnvironment finish
  catch e
    console.log 'caught exception using csv'
    console.log "#{key} =  #{value}" for own key,value of e
    console.log e
    console.log e.reason

  console.log 'finished fillin'

Meteor.startup ->

  # result = Collaborators.findOne {name:'Carol Hope'}, {reactive:false}
  # console.log 'find carol: ',result
  # unless result?
  #   carolId = Collaborators.insert {name:'Carol Hope'}
  #   console.log 'carol id:',carolId
  # else
  #   console.log 'carol collab exists'

  if Meteor.users.find().count() is 0
    addUsers.call this

  if Specimens.find().count() < 2
    importData.call this
