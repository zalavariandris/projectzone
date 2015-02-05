Meteor.methods
  transfereOwnership: (room, toUser) ->
    unless Meteor.users.findOne(toUser)? then alert "cant find user"
    room = if typeof room is 'string'
      Rooms.findOne(room)
    else if room._id?
      Rooms.findOne(room._id)

    OwnsDocument = room.owner is this.userId
    IsAdmin = Roles.userIsInRole(this.userId, 'admin')

    unless OwnsDocument or IsAdmin
      throw new Meteor.Error "no permission", "you don't own this document"
    else
      Rooms.update room._id, $set:
        owner: toUser._id
      ,(error)->
        if error
          console.log error.reason

  'shareWith': (room, withUser)->
    room = if typeof room is 'string'
      Rooms.findOne(room)
    else if room._id?
      Rooms.findOne(room._id)

    OwnsDocument = room.owner is this.userId
    IsAdmin = Roles.userIsInRole(this.userId, 'admin')

    unless OwnsDocument or IsAdmin
      throw new Meteor.Error "no permission", "you don't own this document"
    else
      if room.canEdit?
        Rooms.update room._id, $push: 'canEdit': withUser._id
      else
        Rooms.update room._id, $set: 'canEdit': [withUser._id]

  'revokeShare': (room, fromUser)->
    room = if typeof room is 'string'
      Rooms.findOne(room)
    else if room._id?
      Rooms.findOne(room._id)

    OwnsDocument = room.owner is this.userId
    IsAdmin = Roles.userIsInRole(this.userId, 'admin')

    unless OwnsDocument or IsAdmin
      throw new Meteor.Error "no permission", "you don't own this document"
    else
      Rooms.update room._id, $pull: 'canEdit': fromUser._id
