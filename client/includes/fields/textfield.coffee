
Template.textfield.helpers

  max: (value) -> if value? then value else 1000

  groupClass: (value) -> value ? 'form-group'

  labelClass: (value) -> value ? 'col-md-2 control-label'

  fieldClass: (value) -> value ? 'col-md-3'

  inputClass: (value) -> value ? 'form-control input-md'

Template.textfield.events

  'blur .TF, keypress .TF': Fields.textEntered

  # (event, template) ->
  # #'blur .TF, focusout .TF, keypress .TF': (event, template) ->
  #
  #   unless event.type is 'blur' or event.type is 'focusout' or
  #     (event.type is 'keypress' and event.which is 13)
  #       return true
  #
  #   event.preventDefault()
  #
  #   parentData = Template.parentData(1)
  #   object = parentData.object
  #   collection = parentData.collection
  #
  #   name = template.data.name
  #   id = object._id
  #
  #   original = object?[name]
  #   value = $(event.target).val()
  #
  #   unless value isnt original
  #     console.log 'ignoring, value unchanged.'
  #     return
  #
  #   console.log 'new value!'
  #
  #   set = {$set: {}}
  #   set.$set[name] = value
  #   collection.update {_id:id}, set, (err) ->
  #     if err
  #       console.log 'error updating value:',err
  #     else
  #       # change back to regular text display instead of input
  #       # show a green checkbox next to it for a bit
  #       console.log 'value update successful'
