
ownsDocument = (userId, doc)->
  return doc? and doc.owner is userId

@Rooms = new Mongo.Collection 'rooms'

# if Meteor.isServer then Rooms.remove {}

Rooms.allow
    insert: Meteor.user

    update: (userId, doc)->
        Permissions.canEdit(doc)
        # OwnsDocument = ownsDocument(userId, doc)
        # IsAdmin = Roles.userIsInRole(userId, 'admin')
        # console.log "IsAdmin: #{IsAdmin}, OwnsDocument: #{OwnsDocument}"
        # return IsAdmin or OwnsDocument

    remove: ()->
        return false


Schemas = {}

Schemas.Room = new SimpleSchema
    title:
        type: String
        label: "Title"
        max: 200

    site:
        type: String
        label: "website"
        max: 200
        optional: true

    latlng:
        type: Object
        label: "latlng"
    
    'latlng.lat':
        type: Number
        decimal: true

    'latlng.lng': 
        type: Number
        decimal: true

    createdAt:
        type: Date
        autoValue: ()->
            if this.isInsert
                return new Date
            else if this.isUpsert
                return {$setOnInsert: new Date}
            else
                this.unset()
        denyUpdate: true

    updatedAt:
        type: Date
        autoValue: ->
            if @isUpdate then return new Date
        denyInsert: true
        optional: true

    owner:
        type: String
        autoValue: ()->
            if @isInsert
                this.userId

    canEdit:
        type: [String]
        optional: true


    opened:
        type: Number
        label: "Opened"
        optional: true

    closed:
        type: Number
        label: "Closed"
        optional: true

    validated:
        type: Boolean
        optional: true

    deleted:
        type: Boolean
        optional: true

Rooms.attachSchema Schemas.Room
