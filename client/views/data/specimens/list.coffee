
Template.SpecimenList.onCreated ->
  self = this
  #this.autorun ->
  #  #Subs.subscribe 'specimens' #, options
  #  #self.subscribe 'specimens' #, options

formatDate = (value,object) ->
  if value?
    moment(value).format('MM/DD/YYYY')
  else
    ''
hide = (field) ->
  switch field
    when 'clinical.id' then return true
    when 'stock.id'    then return true
    when 'b.id'        then return true
    when 'gc.id'       then return true
    else return false

Template.SpecimenList.helpers

  tableSettings: ->
    collection: 'specimensTable'
    showFilter: false
    filters: ['specimenListFilter']
    showNavigation: 'auto'
    showColumnToggles: true
    fields: [
      { key: '_id', label: 'S#', sort:'descending'}
      { key: 'clinical.id', label:'CS#', hidden: -> hide 'clinical.id' }
      { key: 'stock.id', label:'BS#', hidden: -> hide 'stock.id' }
      { key: 'b.id', label:'B#', hidden: -> hide 'b.id' }
      { key: 'gc.id', label:'GC#', hidden: -> hide 'gc.id' }
      { key: 'loggedBy.name', label: 'Logged By'}
      { key: 'dateCollected', label:'Collected', fn:formatDate, sortByValue:true }
      { key: 'dateReceived', label:'Received', fn:formatDate, sortByValue:true }
      { key: 'studyCode', label:'Study' }
      { key: 'stock.species', label:'Species' }
      { key: 'collab.name', label:'Collaborator' }
      #  { key: 'storage.display', label:'Stored' }
      { key: 'clinical.tissue', label:'Tissue'}
    ]

  # entering any fields in here causes the filter to *not* work
  filterFields: -> [
    #'_id', 'stock.id', 'b.id', 'gc.id', 'loggedBy.name', 'stock.species', 'studyCode'
    #'dateReceived', 'dateCollected', 'collab.name', 'clinical.tissue'
  ]

Template.SpecimenList.events

  'click .reactive-table tr': (event) ->
    event.preventDefault()
    specimen = this
    # don't continue when it's the header row
    if specimen? and specimen?._id?
      FlowRouter.setParams
        item: 'View'
        id: specimen._id
