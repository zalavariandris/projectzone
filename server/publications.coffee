###
  Publications
  Define Meteor publications to subscribe to on the client.
###

Meteor.publish 'users', (selector)->
    Meteor.users.find()

Meteor.publish 'rooms', (selector)->
    # Rooms._ensureIndex 'latlng': '2dsphere'
    # return Rooms.find latlng: $within: $box: [ [47.42669366522116, 18.921890258789062] , [47.573283112482144, 19.188308715820312] ]
    return Rooms.find selector, {fields: changes: 0, history: 0}

Meteor.publish 'images', (selector)->
  Images.find(selector)

Meteor.publish 'history', (selector)->
    return Rooms.find selector, {fields: changes: 1, history: 1}

Meteor.publish null, ->
  return Meteor.roles.find({})




Meteor.publish '/invites', ->
    # Return list of invites if current user is admin.
    if Roles.userIsInRole(this.userId, ['admin'])
        Invites.find({}, {fields: {"_id": 1, "inviteNumber": 1, "requested": 1, "email": 1, "token": 1, "dateInvited": 1, "invited": 1, "accountCreated": 1}})
    else
        this.ready()
         
Meteor.publish 'inviteCount', ->
  # Return list of invites with ID only.
  Invites.find({}, {fields: {"_id": 1}})