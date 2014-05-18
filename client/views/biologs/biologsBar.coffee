
Template.biologsBar.helpers
  listNavClass:  -> (Session.get 'biologsListNavClass') ? 'nada'
  addNavClass:   -> (Session.get 'biologsAddNavClass') ? 'nada'
  sortNavClass:  -> (Session.get 'biologsSortNavClass') ? 'disabled'
  editNavClass:  -> (Session.get 'biologsEditNavClass') ? 'disabled'
  viewNavClass:  -> (Session.get 'biologsViewNavClass') ? 'disabled'
