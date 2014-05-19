
headerClass = (field) ->
  # if it's the sort field then *not* 'hidden'
  # if it's descending then 'dropup'
  sort = Session.get 'sortBiologList'
  
  if sort?.length > 0 and sort[0]?.length > 1 and sort[0][0] is field
    if sort[0][1] is 'asc'
      ' ' # not hidden and allows default dropdown
    else
      'dropup'
  else
    'hidden'

Template.biologList.helpers

  hsClass:            -> headerClass '_id'
  dnaClass:           -> headerClass 'dna'
  subjectCodeClass:   -> headerClass 'subjectCode'
  studyCodeClass:     -> headerClass 'studyCode'
  tissueClass:        -> headerClass 'tissue.value'
  tissueBankingClass: -> headerClass 'tissue.banking'
  collectedClass:     -> headerClass 'collected.date'
  receivedClass:      -> headerClass 'received.date'
  storageClass:       -> headerClass 'storage.location'
  collabClass:        -> headerClass 'collaborator.name'
  loggedByClass:      -> headerClass 'logged.byName'
  loggedDateClass:    -> headerClass 'logged.date'
  commentsClass:      -> headerClass 'comments'
  #Class: -> headerClass ''

  
    

Template.biologList.events

  'dblclick #biologListTable th': (e, t) ->
    th = $(e.currentTarget)
    sortField = th.data('sort')
    sort = Session.get 'sortBiologList'
    
    #console.log "clicked a header: #{sortField}"
    #console.log "current sort: #{sort}"
    #console.log "which = #{e.which}"
    
    # 1. if the outer array exists and contains at least one element
    # 2. if the first array element is an array with at least two elements
    # 3. if the first element of the inner array matches the name
    if sort?.length > 0 and sort[0]?.length > 1 and sort[0][0] is sortField
      # if the current sort is ascending
      if sort[0][1] is 'asc'
        # then change it to descending
        sort[0][1] = 'desc'
      else # it is descending, so, change it to ascending
        sort[0][1] = 'asc'
    else # doesn't have current sort info, so just use the new setting
      sort = [[ sortField, 'asc' ]]
    
    #console.log "new sort: #{sort}"

    Session.set 'sortBiologList', sort
