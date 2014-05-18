
Template.biologAdd.events
  'click #addBiologButton': (e) -> addBiolog e
  'submit #addBiologForm': (e) -> addBiolog e
  
addBiolog = (e) ->
  e.preventDefault()
  console.log 'add biolog...'

  hs = $('#hs').val()
  
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
        biologData._id = id
        Router.go 'biologView', biologData
  
  else
    # add the has-error and has-feedback to the HS field?
    notifyError 'Please enter, at least, the HS#'


    