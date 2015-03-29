
atPath = (menu, item) ->
  isMenu = (menu is FlowRouter.getParam 'menu')
  isItem = (item is FlowRouter.getParam 'item')
  result = isMenu and isItem
  result

Template.registerHelper 'notAt', (menu, item, be) ->
  if be?.hash? then be = 'disabled'
  return if not atPath menu, item then be else false

Template.registerHelper 'at', (menu, item, be) ->
  if be?.hash? then be = 'active'
  return if atPath menu, item then be else false
