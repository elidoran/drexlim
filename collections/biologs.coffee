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
  insert: -> false
  update: -> false
  remove: -> false

Biologs.deny
  update: (userId, biologData, fieldNames) ->
    # may not edit the HS# field:
    #(_.without(fieldNames, 'hs').length > 0)
    # check permissions to see what the user is allowed to do
    # based on whether they own it, what they're changing, ...
    false
    
Meteor.methods

  addBiolog: (biologData, callback) ->
    console.log 'adding biolog ...'
    unless this.userId? # ensure the user is logged in
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

    # pull out data we want to avoid the Client doing bad things...
    biolog =
      _id: biologData.hs  # the HS# is used as the ID
      dna: biologData?.dna
      subjectCode: biologData?.subjectCode
      studyCode: biologData?.studyCode
      tissue:
        value: biologData?.tissue?.value
        banking: biologData?.tissue?.banking
      collected:
        date: biologData?.collected?.date
         #by: id+name
      received:
        date: biologData?.received?.date
         #by: id+name
      collaborator: 
        name: biologData?.collaborator?.name
      storage:
        location: biologData?.storage?.location
      comments: biologData?.comments
      logged:
        byId: user._id
        byName: user.profile?.name
        date: new Date().getTime()
        
    biologId = Biologs.insert biolog
    
    # wrap with try-catch to avoid interfering with the addBiolog work
    try
      Ops.insert
        op: 'add'
        in: 'Biologs'
        id: biologId
        by:
          id: user._id
          name: user.profile.name
    catch error
      # TODO: record error to log file

    return biologId
    
  editBiolog: (biologChanges, callback) ->
    
    unless this.userId # ensure the user is logged in
      throw new Meteor.Error 401, 'You must login to add a biolog'
      
    # check for the HS# value we need
    unless biologChanges?.hs and biologChanges.hs?.length > 0
      throw new Meteor.Error 400, 'HS# value missing for edit'
    
    # check if there are changes in there...?

    # get full User so we can use their name in the data
    user = Meteor.user()

    # restructure the update values for
    update = toUpdateFormat biologChanges.update

    Biologs.update biologChanges.hs, { $set: update }

    try
      Ops.insert
        op: 'edit'
        in: 'Biologs'
        id: biologChanges.hs
        by:
          id:user._id
          name: user.profile.name
        date: new Date().getTime()
        history: biologChanges.history
    catch error
      # TODO: record error to log file

    return      

toUpdateFormat = (flat) ->

  deep = {}
  
  for key,val of flat
    switch key
      when 'tissue' then deep['tissue.value'] = val
      when 'tissueBanking' then deep['tissue.banking'] = val
      when 'collectedDate' then deep['collected.date'] = val
      when 'receivedDate' then deep['received.date'] = val
      when 'storageLocation' then deep['storage.location'] = val
      when 'collaborator' then deep['collaborator.name'] = val
      else deep[key] = val
  
  return deep
  




