
Template.registerHelper 'valueFor', (object, key) -> #object[key]
    #console.log "object[#{object}]  key[#{key}]"
    if object?
      if object?[key]? then object[key]
      else if key.indexOf '.' > -1
        keys = key.split '.'
        value = object
        value = value[key] for key in keys
        return value

Template.registerHelper 'dateValueFor', (object, key, format) -> #object[key]
    #console.log "object[#{object}]  key[#{key}]"
    if object?
      if object?[key]? then formatDateWithMoment object[key], format
      else if key.indexOf '.' > -1
        keys = key.split '.'
        value = object
        value = value[key] for key in keys
        return formatDateWithMoment value, format

getOriginalTextValue = (value) -> value
getNewTextValue = (value) -> value

getOriginalDateValue = (value) -> formatDateWithMoment value, 'YYYY-MM-DD'
getNewDateValue = (value) -> parseDateWithMoment value

textValueEntered = (event, template, getOriginalValue, getNewValue) ->
  unless event.type is 'blur' or event.type is 'focusout' or
    event.type is 'typeahead:autocompleted' or
    (event.type is 'keypress' and event.which is 13)
      return true

  event.preventDefault()

  parentData = template.parentData ? Template.parentData(1)
  object = parentData.object
  collection = parentData.collection

  name = template.data.name
  id = object._id

  original = getOriginalValue object?[name]
  value = $(event.target).val()
  console.log 'Value from event target = ',value
  unless value isnt original
    console.log 'ignoring, value unchanged.'
    return

  value = getNewValue value
  console.log 'new value! ',value

  set = {$set: {}}
  if name.indexOf '.' > -1
    if template.data?.newValue?._id
      idKey = name.replace 'name', 'refId'
      set.$set[idKey] = template.data.newValue._id
  set.$set[name] = value
  collection.update {_id:id}, set, (err) ->
    if err
      console.log 'error updating value:',err
    else
      # change back to regular text display instead of input
      # show a green checkbox next to it for a bit
      console.log 'value update successful'

@Fields =

  textEntered: (event, template) ->
    textValueEntered event, template, getOriginalTextValue, getNewTextValue


  dateEntered: (event, template) ->
    textValueEntered event, template, getOriginalDateValue, getNewDateValue
