
Template.SpecimenRecent.onCreated ->
  self = this
  self.autorun ->
    Subs.subscribe 'recent-specimens'

Template.SpecimenRecent.helpers

  settings: ->
    collection: Recents
    showFilter: true
    showNavigation: 'auto'
    fields: [
      { key: '_id', label: 'S#'}
      { key: 'loggedBy.name', label: 'Logged By'}
    ]

Template.SpecimenRecent.events
