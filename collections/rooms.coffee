@Rooms = new Mongo.Collection 'rooms'

if Meteor.isServer
    Rooms.remove {}