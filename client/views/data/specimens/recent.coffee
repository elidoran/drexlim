
Template.SpecimenRecent.onCreated ->
  self = this
  self.autorun ->
    # Subs.subscribe 'recent-specimens'
    self.subscribe 'recent-specimens'

Template.SpecimenRecent.helpers

  tableSettings: ->
    collection: Recents.find {from:'specimens'}
    showFilter: false
    showColumnToggles: false
    showNavigation: 'auto'
    fields: [
      { key: 'refId', label: 'S#'}
      { key: 'specimen.loggedBy.name', label: 'Logged By'}
      { key: 'specimen.collab.name', label: 'Collaborator'}
    ]

  filterFields: -> []

Template.SpecimenRecent.events

  'click .reactive-table tr': (event) ->
    event.preventDefault()
    recent = this
    # don't continue when it's the header row
    if recent?.refId?
      FlowRouter.setParams item: 'View', id:recent.refId
