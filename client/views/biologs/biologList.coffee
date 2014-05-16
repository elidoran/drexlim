
Template.biologList.helpers

  biologs: -> Biologs.find {}, { sort: { hs: 1 } }
  biologsCount: -> Biologs.find().count()
