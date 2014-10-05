Meteor.publish 'rooms', (selector)->
    return Rooms.find(selector)