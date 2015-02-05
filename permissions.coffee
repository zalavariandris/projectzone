Permissions = 
    _isAdmin: ->
        Roles.userIsInRole Meteor.userId(), 'admin'

    _isOwnerOf: (doc)->
        doc.owner is Meteor.userId()

    _isShared: (doc)->
        _.contains doc.canEdit, Meteor.userId()

    canEdit: (room)->
        Permissions._isAdmin() or Permissions._isOwnerOf(room) or Permissions._isShared(room)

if Meteor.isClient
    Template.registerHelper 'canEdit', (room)->
        Permissions.canEdit(room)

@Permissions = Permissions