
Template.biologAdd.events
  'click #addBiologButton': (event, template) -> addBiolog event, template
  'submit #addBiologForm': (event, template) -> addBiolog event, template
  
addBiolog = (event, template) ->
  
  # prevent form submission #1
  event.preventDefault()
  
  # get full User so we can use their name in the data
  user = Meteor.user()
  
  unless user # ensure the user is logged in
    notifyError 'You must login to add a biolog'
    return false
    
  # get the HS# as the ID
  hs = template.find('#hs').value
  
  unless hs? and hs.length > 0
    # add the has-error and has-feedback to the HS field?
    notifyError 'Please enter, at least, the HS#'
    return false
  
  # gather all data fields
  biologData = 
    hs: hs
    dna: template.find('#dna').value
    subjectCode: template.find('#subjectCode').value
    studyCode: template.find('#studyCode').value
    tissue: 
      value: template.find('#tissue').value
      banking: template.find('#tissueBanking').value
    collected:
      date: template.find('#collectedDate').value
    received:
      date: template.find('#receivedDate').value
    storage:
      location: template.find('#storageLocation').value # will be id+name
    collaborator:
      name: template.find('#collaborator').value # will be id+name
    comments: template.find('#comments').value
    
  Meteor.call 'addBiolog', biologData, (error, biologId) ->
    if error
      notifyError error.reason
    else
      # no sense adding message when we are routing to the View page
      #notifySuccess 'Biolog added'
      Router.go 'biologView', {_id : biologId}

    