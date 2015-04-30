
Template.StorageList.helpers

  tableSettings: ->
    collection: 'storagesTable'
    showFilter: false
    filters: ['storageListFilter']
    showNavigation: 'auto'
    showColumnToggles: false
    fields: [
      { key: 'refId', label: 'S#', sort: 'asc'}
      { key: 'room', label: 'Room'}
      { key: 'rack', label: 'Rack'}
      { key: 'shelf', label: 'Shelf'}
      { key: 'box', label: 'Box'}
      { key: 'cell', label: 'Cell'}
    ]

  # entering any fields in here causes the filter to *not* work
  filterFields: -> []

Template.SpecimenList.events

  'click .reactive-table tr': (event) ->
    event.preventDefault()
    storage = this
    # don't continue when it's the header row
    # header row doesn't have an object, so, no _id
    if storage?._id? then FlowRouter.setParams item:'View', id:storage._id
