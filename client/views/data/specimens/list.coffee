
#defaultOptions =
#  limit: 3
#  sort: [ '_id', 'asc' ]

Template.SpecimenList.onCreated ->
  self = this
  self.autorun ->
    #options = (Session.get 'specimenListOptions') ? defaultOptions
    ##console.log "SpecimenList options limit=#{options.limit} sort=#{options.sort}"
    ##self.subscribe 'specimens', options
    Subs.subscribe 'specimens' #, options

Template.SpecimenList.helpers

  settings: ->
    collection: Specimens
    showFilter: true
    showNavigation: 'auto'
    fields: [
      { key: '_id', label: 'S#'}
      { key: 'loggedBy.name', label: 'Logged By'}
    ]

Template.SpecimenList.events
