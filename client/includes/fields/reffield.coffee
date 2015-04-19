
RefInfo = {}

Template.reffield.onDestroyed ->
  delete RefInfo[key] for own key of RefInfo

Template.reffield.onRendered ->
  Meteor.typeahead.inject()
  ref = this.data.ref
  refInfo = RefInfo[ref] = {}
  refInfo.searchName = 'search' + ref
  refInfo.data = this.data
  refInfo.parentData = Template.parentData(1)

  if this?.data?.id
    element = $ '#'+this.data.id
    if element?
      element.on 'typeahead:autocompleted', (event,suggestion,datasetName) ->
        #console.log 'Event:',event
        console.log 'suggestion = ',suggestion
        console.log 'datasetName = ',datasetName
        refInfo.data.name = datasetName.replace /_/g, '.'
        refInfo.data.newValue = suggestion
        #console.log 'refInfo: ',refInfo
        Fields.textEntered event, refInfo

defaultValueMapping = (value) -> value.value = value.name ; value
search = (refInfo, query, callback, valueMapping = defaultValueMapping) ->
  if refInfo?.searchName?
    fields = refInfo.fields ? name:1
    sort = refInfo.sort ? ['name','asc']
    limit = refInfo.limit ? 10
    searchOptions = {limit:limit,sort:sort,fields:fields}
    searchName = refInfo.searchName
    Meteor.call searchName, query, searchOptions, (error, result) ->
      if error?
        console.log 'error searching:',error
      else #TODO: return all three fields so we can use our custom template...
        callback result.map valueMapping
  else
    console.log 'no RefInfo?? : ',RefInfo

Template.reffield.helpers

  groupClass: (value) -> value ? 'form-group'

  labelClass: (value) -> value ? 'col-md-2 control-label'

  fieldClass: (value) -> value ? 'col-md-3'

  inputClass: (value) -> value ? 'form-control input-md'

  #TODO: these map to search() because there's no context from autocomplete's call
  searchCollaborators: (query, callback) ->
    RefInfo.Collaborators.fields = name:1,orgName:1
    search RefInfo.Collaborators, query, callback

  searchUsers: (query, callback) ->
    RefInfo.Users.fields = 'profile.name':1
    RefInfo.Users.sort = ['profile.name', 'asc']
    search RefInfo.Users, query, callback, (value) ->
      return _id:value._id,value:value.profile.name,name:value.profile.name

  searchProjects: (query, callback) ->
    RefInfo.Projects.fields = name:1
    search RefInfo.Projects, query, callback
