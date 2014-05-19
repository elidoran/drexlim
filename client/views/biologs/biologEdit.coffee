Template.biologEdit.events
  'click #editBiologButton': (e, t) -> editBiolog e, t
  'submit #editBiologForm' : (e, t) -> editBiolog e, t

biologEditableFieldNames = [
    'dna', 'subjectCode', 'studyCode', 'tissue', 'tissueBanking',
    'collectedDate', 'receivedDate', 'storageLocation', 'collaborator',
    'comments'
  ]
  
editBiolog = (e, t) ->
  # prevent form submission #1
  e.preventDefault()
  
  # check each value against its original and identify only changes
  biologChanges =
    #add the HS# cuz it's the ID
    hs: t.find('#hs').value
    update: {}
    history: {}
    
  gatherValues name, biologChanges, t for name in biologEditableFieldNames
  
  unless biologChanges.hasChanges
    notifyInfo 'Biolog has no changes to save.'
    return false
    
  # remove the 'hasChanges' marker (we're done with it)
  delete biologChanges.hasChanges

  # call server to store changed biolog
  Meteor.call 'editBiolog', biologChanges, (error) ->
    if error
      notifyError error.reason
    else
      notifySuccess 'Biolog changes saved'

gatherValues = (name, changes, t) ->
  # get input element
  input = $(t.find '#'+name)
  # get original value (it's a data attribute)
  original = input.data 'original'
  # get input value
  current = input.val()
  
  # val() doesn't work for the checkbox, so, use the prop function
  if name is 'tissueBanking' then current = input.prop 'checked'
  
  # compare values
  if current isnt original
    # store change by its name
    changes.update[name] = current
    changes.history[name] = original
    changes.hasChanges = true
