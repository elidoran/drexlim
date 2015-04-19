
@Schema = {}

CollectionHooks.defaults.after.update = fetchPrevious:false

@Op =
  getWho: (userId) ->
    user = Meteor.users.findOne _id:userId
    name = user?.profile?.name
    return refId:userId,name:name

  afterInsert: (where) ->
    return (userId, doc) ->
      unless Meteor.isServer then return true
      Meteor.defer ->
        op =
          who: Op.getWho userId
          why:'insert'
          where:'specimens'
          what:doc
        Ops.insert op

      return true

  afterUpdate: (where) ->
    return (userId, doc, fieldNames, modifier, options) ->
      unless Meteor.isServer then return true
      Meteor.defer ->
        info = why:'update', where:where, 'who.refId':userId

        op = do ->
          hourAgo = new Date()
          hourAgo.setHours hourAgo.getHours() - 1
          info.when = $gt:hourAgo
          # NOTE: this combines only if *first* update was less than an hour ago
          # combining subsequent updates in doesn't change the main 'when' value
          Ops.findOne info, {limit:1, fields:{_id:1,what:1}, sort:{when:-1}}

        update = do ->
          changes = []
          for key,index in fieldNames
            changes.push key:key, value:doc[key]
          return $push: how: $each: changes

        if op? and op.what?.refId is doc._id
          Ops.update {_id:op._id}, update

        else
          # NOTE: the 'info.when' value will be ignored, autoValue will set it to new Date()
          # let's delete it anyway.
          delete info.when
          delete info['who.refId']
          info.what = refId:doc._id
          info.how  = update.$push.how.$each
          info.who  = Op.getWho userId
          console.log 'Info: ',info
          Ops.insert info

      return true
