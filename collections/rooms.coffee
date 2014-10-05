@Rooms = new Mongo.Collection 'rooms'

if Meteor.isServer
    Rooms.remove {}



Rooms.allow
    # update: ownsDocument
    update: Meteor.user

    remove: Meteor.user

Meteor.methods
    'room': (attributtes)->
        user = Meteor.user()

        #ensure the user is logged in
        unless user then throw new Meteor.Error 401, "You must login to login!"

        #ensure site has a latlng
        unless attributtes.latlng then throw new Meteor.Error 422, "Please provide a coords"

        # pick out the whitlisted keys
        item = _.extend(_.pick(attributtes, 'latlng', 'title', 'opened', 'closed'),{
            owner: user._id
            submitted: Date.now()
            validated: not @isSimulation
        })

        itemId = Rooms.insert item

        return itemId