
# localValue1 = false
# localValue2 = false
#
# Template.textfield.onRendered ->
#   unless localValue1
#     localValue1 = true
#     console.log 'textfield rendered: '
#     console.log '        this: ',this
#     console.log '        i: ',Template.instance()
#     console.log '        p: ',Template.parentData(1)
#
# Template.textfield.helpers
#
#   testing: ->
#     unless localValue2
#       localValue2 = true
#       console.log 'testing in textfield:'
#       console.log '      this: ',this
#       console.log '      i:',Template.instance()
#       console.log '      p:',Template.parentData(1)
#     return 'testing!'


Template.textfield.events

  'blur .TF, keypress .TF': Fields.textEntered
