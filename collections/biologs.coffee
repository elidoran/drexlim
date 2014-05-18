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
  insert: -> true
  update: -> true
  remove: -> true

Biologs.deny
  update: (userId, biologData, fieldNames) ->
    # may not edit the HS# field:
    (_.without(fieldNames, 'hs').length > 0)
    # check permissions to see what the user is allowed to do
    # based on whether they own it, what they're changing, ...
    #false
    
Meteor.methods

  addBiolog: (biologData, callback) ->
    
    unless this.userId # ensure the user is logged in
      throw new Meteor.Error 401, 'You must login to add a biolog'

    # ensure the required data exists:
    unless biologData?.hs?.length > 0
      throw new Meteor.Error 422, 'Provide, at least, the HS#'

    # check if this biolog has already been entered...
    biologWithSameHS = Biologs.findOne { _id: biologData.hs}
    if biologWithSameHS
      throw new Meteor.Error 302, 'HS# already in use',
        biologWithSameHS._id

    # get full User so we can use their name in the data
    user = Meteor.user()

    # pull out the data we want from the client supplied data
    # NOTE: we could use Underscores' "pick" function, but, we are also
    #       altering the structure of the data
    biolog =
      _id: biologData.hs  # the HS# is used as the ID
      dna: biologData.dna
      subjectCode: biologData.subjectCode
      studyCode: biologData.studyCode
      tissue:
        value: biologData.tissue
        banking: biologData.tissueBanking
      collected:
        date: biologData.collectedDate
        # by: id+name
      received:
        date: biologData.receivedData
        # by: id+name
      #species: biologData.species
      collaborator: biologData.collaborator
      logged: 
        byId: user._id
        byName: user.profile.name
        date: new Date().getTime()
      storage:
        location: biologData.storageLocation
      comments: biologData.comments

    Biologs.insert biolog, (error, biologId) ->
      if error
        throw new Meteor.Error 500, 'Unable to store new Biolog'

  editBiolog: (biologData, callback) ->
    
    
