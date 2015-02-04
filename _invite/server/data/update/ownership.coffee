Meteor.methods
  transfereOwnership: (room, toUser) ->
    unless Meteor.users.findOne(toUser)? then alert "cant find user"
    room = if typeof room is 'string'
      Rooms.findOne(room)
    else if room._id?
      Rooms.findOne(room._id)

    OwnsDocument = room.owner is this.userId
    IsAdmin = Roles.userIsInRole(this.userId, 'admin')
    console.log "owner: ", OwnsDocument, "admin: ", IsAdmin

    unless OwnsDocument or IsAdmin
      throw new Meteor.Error "no permission", "you don't own this document"
    else
      console.log Meteor.users.findOne(toUser._id)
      Rooms.update room._id, $set:
        owner: toUser._id
      ,(error)->
        if error
          console.log error.reason

  'shareWith': (room, withUser)->
    check(withUser, _id: String)

    room if typeof room is 'string'
      Rooms.findOne(room)
    else if room._id?
      Rooms.findOne(room._i d)

    OwnsDocument = room.owner is this.userId

    if OwnsDocument
      if room.canEdit?
        Rooms.update room._id, $push: 'canEdit': room._id
      else
        Rooms.update room._id, $set: 'canEdit': [room._id]

