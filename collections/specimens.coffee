# Specimen

@Specimens = new Mongo.Collection 'specimens'

Specimens.allow
  insert: -> true
  update: -> true
  remove: -> false


Specimens.attachSchema new SimpleSchema
  ###
    Common Properties
  ###
  _id:
    type: Meteor.ObjectID
  accession:
    type: String
    max: 1000
    optional: true
  dateCollected:
    type: Date
    optional: true
  dateCollectedString:
    type: String
    max:50
    optional:true
  dateReceived:
    type: Date
    optional: true
  dateReceivedString:
    type: String
    max:50
    optional:true
  'collab.id': # _id is the _id used in Collaborator collection
    type: Meteor.ObjectID
    optional: true
  'collab.name': #their name so we can access it quickly
    type: String
    optional: true
    max: 500
  'collab.orgId': # the _id used in the organization collection
    type: Meteor.ObjectID
    optional: true
  'collab.orgName': #their name so we can access quickly
    type: String
    max: 500
    optional: true
  'project.id':
    type: Meteor.ObjectID
    optional: true
  'loggedBy.id':
    type: Meteor.ObjectID
    optional:true
  'loggedBy.name':
    type:String
    max:200
    optional:true
  studyCode:
    type: String
    max: 500
    optional:true
  tags:
    type: [String]
    optional: true
  note:
    type: String
    optional: true
  'storage.id':
    type: Meteor.ObjectID
    optional:true
  'storage.display':
    type: String
    optional:true

  ###
    Clinical Properties
  ###
  'clinical.id':
    type: String
    max: 100
    optional:true
  'clinical.tissue':
    type: String
    max: 200
    optional:true
  'clinical.subject':
    type: String
    max: 200
    optional:true
  'clinical.indication':
    type: String
    max: 200
    optional:true
  'clinical.surgeon':
    type: String
    max: 200
    optional:true
  'clinical.place':
    type: String
    max: 200
    optional:true
  'clinical.dob':
    type: Date
    optional:true
  'clinical.storage.id':
    type: Meteor.ObjectID
    optional:true
  'clinical.storage.display':
    type: String
    optional:true

  ###
    Bacterial Stock Properties
  ###
  'stock.id':
    type: String
    max:100
    optional:true
  'stock.species':
    type: String
    max:200
    optional:true
  'stock.strainId':
    type: String
    max:200
    optional:true
  'stock.phenotype':
    type: String
    max:200
    optional:true
  'stock.passage':
    type: [String]
    optional:true
  'stock.dateFrozen':
    type: Date
    optional:true
  'stock.storedBy.id':
    type:Meteor.ObjectID
    optional:true
  'stock.storedBy.name':
    type: String
    max:200
    optional:true
  'stock.storage.id':
    type: Meteor.ObjectID
    optional:true
  'stock.storage.display':
    type: String
    optional:true

  ###
    B properties
  ###
  'b.id':
    type: String
    max:100
    optional:true
  'b.from.id':
    type:String
    max:100
    optional:true
  'b.from.type':
    type:String
    max:2
    allowedValues: ['BS', 'CS']
    optional:true
  'b.dateExtracted':
    type:Date
    optional:true
  'b.extractedBy.id':
    type: Meteor.ObjectID
    optional:true
  'b.extractedBy.name':
    type:String
    max:200
    optional:true
  'b.concentration':
    type: String
    max:100
    optional:true
  'b.volume':
    type:String
    max:100
    optional:true

  ###
    General Construct properties
  ###
  'gc.id':
    type: Meteor.ObjectID
    optional:true
  'gc.madeBy.id':
    type: Meteor.ObjectID
    optional:true
  'gc.madeBy.name':
    type:String
    max:200
    optional:true
  'gc.genotype':
    type:String
    max:200
    optional:true
  'gc.plasmid':
    type: String
    max:200
    optional:true
  'gc.resistance':
    type:String
    max:500
    optional:true
  'gc.concentration':
    type:String
    max:100
    optional:true
  'gc.storage.id':
    type: Meteor.ObjectID
    optional:true
  'gc.storage.display':
    type: String
    optional:true

Meteor.methods

  deleteSpecimen: ->
    console.log 'Archive instead?'
