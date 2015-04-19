
@Users = Meteor.users

Schema.CreatedAndUpdated = new SimpleSchema
  createdAt:
    type: Date
    autoValue: ->
      if this.isInsert
        result = new Date()

      else if this.isUpsert
        reuslt = $setOnInsert:new Date()

      else
        this.unset()

      return result
  updatedAt:
    type: Date
    autoValue: -> if this.isUpdate then return new Date()
    denyInsert: true
    optional:true

Schema.UserCountry = new SimpleSchema
  name:
    type: String
  code:
    type: String
    regEx: /^[A-Z]{2}$/

Schema.UserProfile = new SimpleSchema
  name:
    type: String
    max: 200
    min: 1
    index:true
  # firstName:
  #   type: String
  #   regEx: /^[a-zA-Z-]{2,25}$/
  #   optional: true
  # lastName:
  #   type: String
  #   regEx: /^[a-zA-Z]{2,25}$/
  #   optional: true
  # birthday:
  #   type: Date
  #   optional: true
  # gender:
  #   type: String
  #   allowedValues: [
  #     'Male'
  #     'Female'
  #   ]
  #   optional: true
  # organization:
  #   type: String
  #   regEx: /^[a-z0-9A-z .]{3,30}$/
  #   optional: true
  # website:
  #   type: String
  #   regEx: SimpleSchema.RegEx.Url
  #   optional: true
  # bio:
  #   type: String
  #   optional: true
  country:
    type: Schema.UserCountry
    optional: true

Schema.User = new SimpleSchema [
  Schema.CreatedAndUpdated
  emails:
    type: [ Object ]
    optional: false
  'emails.$.address':
    type: String
    # emails are so tricky, avoid any complicated regular expressions
    # just expect something before and after an at symbol which doesn't contain
    # space or an at symbol.
    regEx: /^[^@ \r\n]+@[^@ \r\n]+$/#SimpleSchema.RegEx.Email
  'emails.$.verified':
    type: Boolean
  profile:
    type: Schema.UserProfile
    optional: true
  services:
    type: Object
    optional: true
    blackbox: true
  # Add `roles` to your schema if you use the meteor-roles package.
  # Option 1: Object type
  # If you specify that type as Object, you must also specify the
  # `Roles.GLOBAL_GROUP` group whenever you add a user to a role.
  # Example:
  # Roles.addUsersToRoles(userId, ["admin"], Roles.GLOBAL_GROUP);
  # You can't mix and match adding with and without a group since
  # you will fail validation in some cases.
  roles:
    type: Object
    optional: true
    blackbox: true
  # Option 2: [String] type
  # If you are sure you will never need to use role groups, then
  # you can specify [String] as the type
  #roles:
  #  type: [ String ]
  #  optional: true
]

Meteor.users.attachSchema Schema.User


if Meteor.isServer

  Meteor.methods

    searchUsers: (query, options={limit:10,sort:['name','asc']}) ->
      options.limit = Math.min 10, Math.abs options.limit
      options.sort ?= sort:['profile.name','asc']
      # need non-global with caret for indexed, which makes a 'prefix' index
      #regex = new RegExp "#{query}", 'gi'
      regex = new RegExp "^#{query}", 'i'
      cursor = Users.find {'profile.name':{$regex:regex}}, options
      return cursor.fetch()
