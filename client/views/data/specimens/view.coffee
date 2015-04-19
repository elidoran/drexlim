
Template.SpecimenView.onCreated ->
  self = this
  this.autorun ->
    specimenId = FlowRouter.getParam 'id'
    if specimenId?
      self.specimenId = specimenId # store on template for helpers
      #SingleSubs.subscribe 'singleSpecimen', specimenId
      self.subscribe 'singleSpecimen', specimenId

#Template.SpecimenView.onRendered ->

Template.SpecimenView.onDestroyed ->
  delete this.specimenId  # delete as part of 'cleanup' just to be certain

Template.SpecimenView.helpers
  newDate: -> new Date()
  specimen: ->
    # properties set in the above callbacks are in the instance's *view* property
    specimenId = Template.instance()?.specimenId
    if specimenId?
      specimen = Specimens.findOne _id:specimenId
      if specimen?
        if specimen?._id is specimenId
          Meteor.call 'recentSpecimen', specimenId
        return specimen

  collection: -> Specimens
  #specimenId: -> Template.instance()?.specimenId
  baseFields: (specimen) ->
    # how to access another helper from this helper? we want the specimen...

    return {
      collection: Specimens
      id: Template.instance()?.specimenId
      object: specimen
      array: [
        #TODO: assume 'text' if not specified?
        #{name:'accession', type:'text', label: {text:'Accession'}}
        {name:'dateCollected', type:'date', label:{text:'Collected'}}
        #{name:'dateReceived', type:'date', label:{text:'Received'}}
      ]
    }
