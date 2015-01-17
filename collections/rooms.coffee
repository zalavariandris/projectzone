
ownsDocument = (userId, doc)->
  return doc? and doc.owner is userId

@Rooms = new Mongo.Collection 'rooms'

Rooms.allow
    update: ownsDocument
    # update: Meteor.user

    remove: ()->
        return falser

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

Schemas = {}

Schemas.Room = new SimpleSchema
    title:
        type: String
        label: "Title"
        max: 200

    submitted:
        type: Date
        label: "Submitted"
        blackbox: true
        autoform:
            type: 'hidden'

    opened:
        type: Number
        label: "Opened"
        optional: true

    closed:
        type: Number
        label: "Closed"
        optional: true

    # latlng
    # owner
    
    validated:
        type: Boolean
        optional: true

Rooms.attachSchema Schemas.Room
