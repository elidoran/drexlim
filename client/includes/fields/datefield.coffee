
Template.datefield.helpers

  max: (value) -> if value? then value else 1000

  groupClass: (value) -> value ? 'form-group'

  labelClass: (value) -> value ? 'col-md-2 control-label'

  fieldClass: (value) -> value ? 'col-md-3'

  inputClass: (value) -> value ? 'form-control input-md'

#parseDateWithMoment

Template.datefield.events

  'blur .DF, keypress .DF': Fields.dateEntered
