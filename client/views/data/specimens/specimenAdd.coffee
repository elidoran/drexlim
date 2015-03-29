
Template.SpecimenAdd.events

  'submit #AddSpecimenForm': (event, template) ->
    event.preventDefault()

    id = template.find('#sid').value

    Specimens.insert {_id: id}, (error, id) ->
      if error? then notifyError error.reason
      else
        #FlowRouter.go '/app/data/Specimen/View/:id', {id: id}
        FlowRouter.setParams
          how: 'View'
          id: id
