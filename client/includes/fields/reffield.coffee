
Template.reffield.onRendered ->
  Meteor.typeahead.inject()

defaultValueMapping = (value) -> value.value = value.name ; value
userValueMapping = (value) ->
  return _id:value._id,value:value.profile.name,name:value.profile.name
DEFAULT =
  FIELDS:
    Collaborators: name:1,orgName:1
    Users: 'profile.name':1
    Projects: name:1
    Storages:{}
  SORT:
    Collaborators: ['name','asc']
    Users: ['profile.name','asc']
    Projects: ['name','asc']
    Storages: ['room','asc']

Template.reffield.helpers

  search: (query, callback) ->
    valueMapping = if this.ref is 'Users' then userValueMapping else defaultValueMapping
    fields = this.fields ? DEFAULT.FIELDS[this.ref]
    sort = this.sort ? DEFAULT.SORT[this.ref]
    limit = this.limit ? 10
    searchOptions = fields:fields,sort:sort,limit:limit
    searchName = 'search' + this.ref
    Meteor.call searchName, query, searchOptions, (error, result) ->
      if error?
        console.log 'error searching:',error
      else #TODO: return all three fields so we can use our custom template...
        callback result.map valueMapping

Template.reffield.events

  'typeahead:opened .RF': (event, template) ->
    console.log 'opened *event'

  'typeahead:closed .RF': (event, template) ->
    console.log 'closed *event'

  'typeahead:autocompleted .RF': (event, template, suggestion, datasetName) ->
    console.log 'autocompleted *event'

  'typeahead:selected .RF': (event, template, suggestion, datasetName) ->
    console.log 'selected *event'
    console.log 'suggestion = ',suggestion
    console.log 'datasetName = ',datasetName
    #refInfo.data.name = datasetName.replace /_/g, '.'
    #refInfo.data.newValue = suggestion
    #console.log 'refInfo: ',refInfo
    #Fields.textEntered event, refInfo

  'keypress .RF': (event, template) ->
    # we should have a *new* value which isn't in the ref'd collection yet
    # we must *insert* that _before_ passing on to the fields event handler
    # with the new value in refInfo.data.newValue
    # also need the name with underscores replaced in refInfo.data.name
    console.log 'keypress this: ',this
    switch Fields.eventType event
      when 'E'
        template.$('.RF').typeahead('close')
        event.preventDefault()
        #console.log 'event: ',event
        #console.log 'template: ',template
        {collection, object} = Template.parentData 1
        key = template.data.name
        console.log 'field name: ',key
        originalName = Fields.subValue object, key
        name = $(event.target).val()
        console.log 'current name: ',name
        console.log 'original name: ',originalName
        if name isnt originalName
          # insert into collection... but, we need to know more than name for
          # inserting a user... which we can't do... so... need some way to
          # deny inserting a new user. probably should make user's have a Member
          # document too, and, then we *can* insert a new one of those. it
          # just won't have a login.
          # or use Collaborators? no we need a specific search for it.
          

    return true

    #Fields.textEntered event, refInfo
