
Template.table.helpers

  filterId: ->
    id = Template.parentData(0).id ? 'the'
    "#{id}Filter"

  tableId:  ->
    id = Template.parentData(0).id ? 'the'
    "#{id}Table"
