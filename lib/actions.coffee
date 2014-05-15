# Actions
#
# by specifying each bit of work as an "Action" we can then define corresponding
# "ActionPermission" a user must have in order to perform the Action.
# An ActionPermission collection can be made, with one instance per user, which
# contains all the Action's the user is allowed to do.
#
# Name:  Allow 
# Collection: Allows
# Method: isAllowed
# Content Sample:
#   Allow:
#     ActionName (or ID, or whatever) : true? ''? 
#     ...
#

