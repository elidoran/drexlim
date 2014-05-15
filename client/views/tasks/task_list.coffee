Template.taskList.helpers
  tasks: -> Tasks.find {}, { sort: { submitted: 1 } }
  
