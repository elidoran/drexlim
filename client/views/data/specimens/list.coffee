
Template.SpecimenList.onCreated ->
  self = this
  this.autorun ->
    #Subs.subscribe 'specimens' #, options
    self.subscribe 'specimens' #, options

Template.SpecimenList.helpers

  tableSettings: ->
    collection: Specimens
    showFilter: false
    filters: ['specimenListFilter']
    showNavigation: 'auto'
    showColumnToggles: true
    fields: [
      { key: '_id', label: 'S#', sort:'descending'}
      { key: 'loggedBy.name', label: 'Logged By'}
    ]

  filterFields: -> [
    '_id', 'BS', 'B', 'GC', 'loggedBy.name', 'species'
  ]

Template.SpecimenList.events

  'click .reactive-table tr': (event) ->
    event.preventDefault()
    specimen = this
    FlowRouter.go "/app/data/Specimen/View/#{specimen._id}"
