
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

    remove: (userId, doc)->
        Roles.userIsInRole userId, 'webmaster'


@Schemas = {}

Schemas.Room = new SimpleSchema
    'title':
        type: String
        label: "Title"
        max: 200

    'type':
        type: String
        label: "Type"
        max: 200
        defaultValue: "project"
        allowedValues: ['project', 'alapítvány', 'egyesület', 'klub']

    'site':
        type: String
        label: "website"
        max: 200
        optional: true

    'latlng':
        type: Object
        label: "latlng"
    
    'latlng.lat':
        type: Number
        decimal: true

    'latlng.lng': 
        type: Number
        decimal: true

    'opened':
        type: Number
        label: "Opened"
        optional: true

    'closed':
        type: Number
        label: "Closed"
        optional: true

    'deleted':
        type: Boolean
        optional: true

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

    history:
        type:[Object]
        optional: true
        autoValue: ->
            fields = ['title', 'opened', 'closed', 'latlng', 'site', 'deleted']
            IsSet = _.some (@field(f).isSet for f in fields)

            if IsSet
                # get current data
                data = if @isInsert
                    {}
                else
                    _.pick Rooms.findOne(@docId), fields

                # push date
                data.date = new Date
                data.updatedBy = @userId
                # update new fields
                for f in fields
                    if @field(f).isSet
                        data[f] = @field(f).value

                # update histroy
                if @isInsert
                    return [data]
                else
                    return $push: data
            else
                @unset()

    'history.$.date':
        type: Date

    'history.$.updatedBy':
        type: String

    'history.$.title':
        type: String
        label: "Title"
        max: 200

    'history.$.site':
        type: String
        label: "website"
        max: 200
        optional: true

    'history.$.latlng':
        type: Object
        label: "latlng"
    
    'history.$.latlng.lat':
        type: Number
        decimal: true

    'history.$.latlng.lng': 
        type: Number
        decimal: true

    'history.$.opened':
        type: Number
        label: "Opened"
        optional: true

    'history.$.closed':
        type: Number
        label: "Closed"
        optional: true

    'history.$.deleted':
        type: Boolean
        optional: true

    changes:
        type:[Object]
        optional: true
        autoValue: ->
            fields = ['title', 'opened', 'closed', 'latlng', 'site', 'deleted']

            IsSet = _.some (@field(f).isSet for f in fields)
            if IsSet
                current = Rooms.findOne(@docId) or {}
                change = {
                    date: new Date
                    updatedBy: @userId
                }
                for f in fields
                    change[f] = @field(f).value if @field(f).isSet and @field(f).value isnt current[f]

                if @isInsert
                        return [change]
                    else
                        return $push: change
            else
                @unset()

    'changes.$.date':
        type: Date

    'changes.$.updatedBy':
        type: String

    'changes.$.title':
        type: String
        label: "Title"
        max: 200
        optional: true

    'changes.$.site':
        type: String
        label: "website"
        max: 200
        optional: true

    'changes.$.latlng':
        type: Object
        label: "latlng"
        optional: true
    
    'changes.$.latlng.lat':
        type: Number
        decimal: true

    'changes.$.latlng.lng': 
        type: Number
        decimal: true

    'changes.$.opened':
        type: Number
        label: "Opened"
        optional: true

    'changes.$.closed':
        type: Number
        label: "Closed"
        optional: true

    'changes.$.deleted':
        type: Boolean
        optional: true

    owner:
        type: String
        autoValue: ()->
            if @isInsert
                this.userId

    canEdit:
        type: [String]
        optional: true


Rooms.attachSchema Schemas.Room
