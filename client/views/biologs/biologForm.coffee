Template.biologForm.events
  'click #biologButton': (e, t) -> saveBiolog e, t
  'submit #biologForm' : (e, t) -> saveBiolog e, t

saveBiolog = (e, t) ->
  if Session.equals 'biologsAddNavClass', 'active'
    addBiolog e, t
  else
    editBiolog e, t

addBiolog = (e) ->

  # prevent form submission #1
  e.preventDefault()

  # get the HS#, it's the only required field, and it becomes the _id
  hs = $('#hs').val()
  
  # only continue if we have a valid HS#
  if hs? and hs.length > 0
    biologData = 
      hs: hs
      dna: $('#dna').val()
      subjectCode: $('#subjectCode').val()
      studyCode: $('#studyCode').val()
      tissue: $('#tissue').val()
      tissueBanking: $('#tissueBanking').val()
      collectedDate: $('#collectedDate').val()
      receivedDate: $('#receivedDate').val()
      stored: $('#storageLocation').val() # will be id+name
      collaborator: $('#collaborator').val() # will be id+name
      comments: $('#comments').val()
      #loggedBy id+name is done server side in method call

    Meteor.call 'addBiolog', biologData, (error, id) ->
      if error then notifyError error.reason
      else
        notifySuccess 'Biolog created'
        biologData._id = id
        Router.go 'biologView', biologData
  
  else
    # add has-error and has-feedback to input field?
    notifyError 'Please enter, at least, the HS#'


editBiolog = (e, t) ->
  # prevent form submission #1
  e.preventDefault()
  
  biologData = 
    dna: t.find('#dna').val()
    subjectCode: t.find('#subjectCode').val()
    studyCode: t.find('#studyCode').val()
    tissue: t.find('#tissue').val()
    tissueBanking: t.find('#tissueBanking').val()
    collectedDate: t.find('#collectedDate').val()
    receivedDate: t.find('#receivedDate').val()
    stored: t.find('#storageLocation').val() # will be id+name
    collaborator: t.find('#collaborator').val() # will be id+name
    comments: t.find('#comments').val()
    #loggedBy id+name is done server side in method call

  Meteor.call 'editBiolog', biologData, (error, id) ->
    if error then notifyError error.reason
    else
      biologData._id = id
      notifySuccess 'Biolog changes saved'
      Router.go 'biologView', biologData
    
  # prevent form submission #2
  return false

