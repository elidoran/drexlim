
Template.SpecimenList.onCreated ->
  self = this
  this.autorun ->
    #Subs.subscribe 'specimens' #, options
    self.subscribe 'specimens' #, options

formatDate = (value) -> moment(value).format('MM/DD/YYYY')

Template.SpecimenList.helpers

  tableSettings: ->
    collection: Specimens
    showFilter: false
    filters: ['specimenListFilter']
    showNavigation: 'auto'
    showColumnToggles: true
    fields: [
      { key: '_id', label: 'S#', sort:'descending'}
      { key: 'clinical.id', label:'CS#' }
      { key: 'stock.id', label:'BS#' }
      { key: 'b.id', label:'B#' }
      { key: 'gc.id', label:'GC#' }
      { key: 'loggedBy.name', label: 'Logged By'}
      { key: 'dateCollected', label:'Collected', fn:formatDate }
      { key: 'dateReceived', label:'Received', fn:formatDate }
      { key: 'studyCode', label:'Study' }
      { key: 'stock.species', label:'Species' }
      { key: 'collab.name', label:'Collaborator' }
      #  { key: 'storage.display', label:'Stored' }
      { key: 'clinical.tissue', label:'Tissue'}
    ]

  filterFields: -> [
    '_id', 'stock.id', 'b.id', 'gc.id', 'loggedBy.name', 'stock.species'
  ]

Template.SpecimenList.events

  'click .reactive-table tr': (event) ->
    event.preventDefault()
    specimen = this
    #FlowRouter.go "/app/data/Specimen/View/#{specimen._id}"
    FlowRouter.setParams
      item: 'View'
      id: specimen._id
