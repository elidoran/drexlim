
Template.taskItem.helpers
  isntArchived: -> not this?.archived?
  
  idCount: ->
    count = 0
    if this?.results? then count++ for key of this.results
    count
    
  dnaCount: ->
    count = 0
    if this?.results? then count++ for key,val of this.results when val? and val.length > 0
    count
    
Template.taskItem.events

  'click .archiveTask': (e) ->
    e.preventDefault()
    term = $(e.target).data 'term'
    console.log "archiveTask: #{term}"
    task = Tasks.findOne { term: term }
    if task? 
      Meteor.call 'archiveTask', task, (error, id) ->
        if (error) then notifyError error.reason


