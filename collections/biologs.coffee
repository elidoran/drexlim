# Biolog
#  HS#
#  DNA#
#  StudyCode
#  Tissue
#  [Subject] Family Name or Code
#  [Subject] First Name
#  [Subject] Last Name
#  DOB
#  Sex
#  Collected (date)
#  Received (date)
#  Tissue Banking (yes/no)
#  Species
#  Collaborator (full name)
#  Logged By (full name)
#  [Storage Location] Freezer/Refrigerator
#  [Storage Location] Rack/Box
#  Comments

@Biologs = new Meteor.Collection 'biologs'

Biologs.allow
  update: -> true
  remove: -> true

Biologs.deny
  update: (userId, workday, fieldNames) ->
    # may only edit the following field:
    #(_.without(fieldNames, 'note').length > 0)
    # can change the note?
    # check permissions to see what the user is allowed to do
    # based on whether they own it, what they're changing, ...
    false
    
Meteor.methods

  addBiolog: (biologData, callback) ->
    
    user = Meteor.user()
    
    unless user # ensure the user is logged in
      throw new Meteor.Error 401, 'You must login to add a biolog'

    # ensure the required data exists:
    #unless biologData.?
    #  throw new Meteor.Error 422, 'Provide ...'

    # check if this biolog has already been entered... how? which data is unique?
    #sameBiolog = Worktimes.findOne 
    #  userId: timeEntryData.userId ? user._id
    #  term: taskData.term
    #if sameBiolog
    #  throw new Meteor.Error 302, 'Biolog has already been added',
    #      taskWithSameTerm._id

    # pull out the data we want from the client supplied data
    biolog =
      hs: biologData.hs
      dna: biologData.dna
      studyCode: biologData.studyCode
      tissue: biologData.tissue
      #subject:
      #  familyName: biologData.familyName
      #  code: biologData.subjectCode
      #  firstName: biologData.firstName
      #  middleName: biologData.middleName
      #  dob: biologData.dob
      #  sex: biologData.sex
      collectedDate: biologData.collectedDate
      receivedDate: biologData.receivedData
      tissueBanking: biologData.tissueBanking
      species: biologData.species
      collaborator: biologData.collaborator
      logged: 
        byId: user._id
        byName: user.profile.name
        date: new Date().getTime()
      storageLocationId: biologData.storageLocationId
      comments: biologData.comments

    Biologs.insert biolog, (error, biologId) ->
      if error
        throw new Meteor.Error 500, 'Unable to store new Biolog'


