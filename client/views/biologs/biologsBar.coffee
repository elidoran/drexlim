
Template.biologsBar.helpers
  listNavClass:  -> (Session.get 'biologsListNavClass') ? ' '
  addNavClass:   -> (Session.get 'biologsAddNavClass') ? ' '
  sortNavClass:  -> (Session.get 'biologsSortNavClass') ? 'disabled'
  editNavClass:  -> (Session.get 'biologsEditNavClass') ? 'disabled'
  viewNavClass:  -> (Session.get 'biologsViewNavClass') ? 'disabled'
