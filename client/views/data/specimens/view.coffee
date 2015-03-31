
Template.SpecimenView.onCreated ->
  console.log 'SpecimenView CREATED'
  Session.set 'inView', true
  self = this
  this.autorun ->
    specimenId = FlowRouter.getParam 'id'
    #specimenId = FlowRouter.current().params.id
    console.log "SpecimenView Autorun specimenId=#{specimenId}"
    if specimenId?
      console.log 'subscribing with ', specimenId
      self.specimenId = specimenId # store on template for helpers
      #console.log 'inside autorun this=', this
      #console.log 'inside autorun self=', self
      #SingleSubs.subscribe 'singleSpecimen', specimenId
      self.subscribe 'singleSpecimen', specimenId

Template.SpecimenView.onRendered ->
  console.log 'SpecimenView RENDERED : ', this.specimenId
  #console.log 'this=', this

Template.SpecimenView.onDestroyed ->
  console.log 'SpecimenView DESTROYED : ', this.specimenId
  #console.log 'this=', this
  #delete this.specimenId  # delete as part of 'cleanup' just to be certain
  Session.set 'inView', false

Template.SpecimenView.helpers

  specimen: ->
    # properties set in the above callbacks are in the instance's *view* property
    specimenId = Template.instance()?.specimenId
    console.log 'SpecimenView HELPER specimenId=', specimenId
    if specimenId?
      Specimens.findOne specimenId
    else
      return {id:'no ID provided to find'}
