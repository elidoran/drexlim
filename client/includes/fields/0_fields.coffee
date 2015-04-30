
Template.registerHelper 'valueFor', (object, key) -> #object[key]
    #console.log "object[#{object}]  key[#{key}]"
    if object?
      if object?[key]? then object[key]
      else if key.indexOf '.' > -1
        return Fields.subValue object, key

Template.registerHelper 'dateValueFor', (object, key, format) -> #object[key]
    #console.log "object[#{object}]  key[#{key}]"
    if object?
      if object?[key]? then formatDateWithMoment object[key], format
      else if key.indexOf '.' > -1
        value = Fields.subValue object, key
        return formatDateWithMoment value, format

Template.registerHelper 'getMax', (value) -> if value? then value else 1000

Template.registerHelper 'getGroupClass', (value) -> value ? 'form-group'

Template.registerHelper 'getLabelClass', (value) -> value ? 'col-md-2 control-label'

Template.registerHelper 'getFieldClass', (value) -> value ? 'col-md-3'

Template.registerHelper 'getInputClass', (value) -> value ? 'form-control input-md'


getOriginalTextValue = (object, key) ->
  value = Fields.subValue object, key

getNewTextValue = (value) -> value

getOriginalDateValue = (value) -> formatDateWithMoment getOriginalTextValue(value), 'YYYY-MM-DD'
getNewDateValue = (value) -> parseDateWithMoment value

textValueEntered = (event, template, getOriginalValue, getNewValue) ->
  unless Fields.isSubmitEvent event then return true

  #event.preventDefault()

  parentData = template.parentData ? Template.parentData(1)
  object = parentData.object
  collection = parentData.collection

  name = template.data.name
  id = object._id

  console.log "id[#{id}]  name[#{name}]"
  original = getOriginalValue object, name
  value = $(event.target).val()
  console.log 'Value from event target = ',value
  console.log 'original value: ',original

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

SUBMIT_TYPES = A:true, S:true, E:true, T:true

@Fields =

  subValue: (object, key) ->
    keys = key.split '.'
    value = object
    value = value?[key] for key in keys
    return value

  isSubmitEvent: (event) ->
    return SUBMIT_TYPES?[Fields.eventType event]?

  eventType: (event) ->
    switch event.type
      when 'typeahead:autocompleted' then 'A'
      when 'typeahead:selected' then 'S'
      #when 'blur' or 'focusout' then ''
      when 'keypress'
        if event.which      is 13 then 'E'
        else if event.which is  9 then 'T'
        else if event.which is 27 then '!' # escape
        else null # we don't care about the keypress
      else undefined # we don't care about the event type

  textEntered: (event, template) ->
    textValueEntered event, template, getOriginalTextValue, getNewTextValue


  dateEntered: (event, template) ->
    textValueEntered event, template, getOriginalDateValue, getNewDateValue
