
Template.taskSubmit.events
  'click #addTermButton': (e) -> addTerm e
  'submit #addTermForm' : (e) -> addTerm e

addTerm = (e) ->
    e.preventDefault()
    input = $ '#termInput'
    term = input.val()
    input.val ''
    console.log "add #{term}"
    if term? and term.length > 0
      taskData = 
        term: term
  
      Meteor.call 'newTask', taskData, (error, id) ->
        if error then throwError error.reason
    
    else
      throwError 'Please enter a term'

