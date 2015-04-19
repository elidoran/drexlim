
Meteor.publish null, ->
  return Meteor.roles.find {}

# API Docs:
#  http://alanning.github.io/meteor-roles/classes/Roles.html


# Roles.addUsersToRoles(bobsUserId, ['manage-team','schedule-game'])
# // internal representation - no groups
# // user.roles = ['manage-team','schedule-game']
#
# Roles.addUsersToRoles(joesUserId, ['manage-team','schedule-game'], 'manchester-united.com')
# Roles.addUsersToRoles(joesUserId, ['player','goalie'], 'real-madrid.com')
# // internal representation - groups
# // NOTE: MongoDB uses periods to represent hierarchy so periods in group names
# //   are converted to underscores.
# //
# // user.roles = {
# //   'manchester-united_com': ['manage-team','schedule-game'],
# //   'real-madrid_com': ['player','goalie']
# // }


# Check user roles before publishing sensitive data:
# // server/publish.js
#
# // Give authorized users access to sensitive data by group
# Meteor.publish('secrets', function (group) {
#   if (Roles.userIsInRole(this.userId, ['view-secrets','admin'], group)) {
#
#     return Meteor.secrets.find({group: group});
#
#   } else {
#
#     // user not authorized. do not publish secrets
#     this.stop();
#     return;
#
#   }
# });

# Prevent access to certain functionality, such as deleting a user:
# // server/userMethods.js
#
# Meteor.methods({
#   /**
#    * delete a user from a specific group
#    *
#    * @method deleteUser
#    * @param {String} targetUserId _id of user to delete
#    * @param {String} group Company to update permissions for
#    */
#   deleteUser: function (targetUserId, group) {
#     var loggedInUser = Meteor.user()
#
#     if (!loggedInUser ||
#         !Roles.userIsInRole(loggedInUser,
#                             ['manage-users','support-staff'], group)) {
#       throw new Meteor.Error(403, "Access denied")
#     }
#
#     // remove permissions for target group
#     Roles.setUserRoles(targetUserId, [], group)
#
#     // do other actions required when a user is removed...
#   }
# })


# Manage a user's permissions:
# // server/userMethods.js
#
# Meteor.methods({
#   /**
#    * update a user's permissions
#    *
#    * @param {Object} targetUserId Id of user to update
#    * @param {Array} roles User's new permissions
#    * @param {String} group Company to update permissions for
#    */
#   updateRoles: function (targetUserId, roles, group) {
#     var loggedInUser = Meteor.user()
#
#     if (!loggedInUser ||
#         !Roles.userIsInRole(loggedInUser,
#                             ['manage-users','support-staff'], group)) {
#       throw new Meteor.Error(403, "Access denied")
#     }
#
#     Roles.setUserRoles(targetUserId, roles, group)
#   }
# })
