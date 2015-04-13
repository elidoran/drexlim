
# TODO: make a template which renders a select so we can put this on its events
# to avoid redoing this for every select we use.
Template.SpecimenAdd.onRendered ->
  console.log 'SpecimenAdd rendered'
  $('#projectId').chosen
    disable_search_threshold: 3
    placeholder_text_single: 'Select Project'
    no_results_text: 'No matching project'
    width: '95%'
    display_disabled_options: false
    display_selected_options: false

  $('#tags').chosen
    disable_search_threshold: 3
    placeholder_text_multiple: 'Add Tags'
    no_results_text: 'No matching tag'
    width: '95%'
    display_disabled_options: false
    display_selected_options: false

  #TODO: add collaborator select. do we create a modal popup so we're not
  #      publishing *all* collaborator(id+name) values to render the select?

  #TODO: listen to event for collaborator selected so we can move the name
  #      to the collaboratorName hidden field.

  
Template.SpecimenAdd.helpers



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
