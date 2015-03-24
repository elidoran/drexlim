
Template.specimenAdd.events

  'submit #AddSpecimenForm': (event, template) ->
    event.preventDefault()

    id = template.find('#sid').value

    Specimens.insert {_id: id}, (error, id) ->
      if error? then notifyError error.reason
      else
        Router.go 'specimenView', {id: id}
