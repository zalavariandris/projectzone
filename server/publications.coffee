Meteor.publish 'users', (selector)->
    Meteor.users.find()

Meteor.publish 'rooms', (selector)->
    # Rooms._ensureIndex 'latlng': '2dsphere'
    # return Rooms.find latlng: $within: $box: [ [47.42669366522116, 18.921890258789062] , [47.573283112482144, 19.188308715820312] ]
    return Rooms.find selector


Meteor.publish null, ->
  return Meteor.roles.find({})