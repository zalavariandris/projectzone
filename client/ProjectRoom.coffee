Template.body.helpers
    rooms: ->
        Rooms.find()

    selectedItem: ->
        Rooms.findOne Session.get('selection')

    isSelected: ->
        item = Template.currentData()
        selection = Rooms.findOne Session.get('selection')

        unless item? and selection? then return null
        return item._id is selection._id

Template.body.events
Template.body.events
    'dblclick #room-map': (event, template)->
        newId = Rooms.insert
            latlng: event.latlng
            title: "-room title-"
        Session.set 'selection', newId

    'click #room-map':(event, template)->
        # if the event.target has a ".marker" parent 
        # then the user clicked on a marker, so select the correspondent room
        # otherwise, the user was clicked on the map
        # so deselect all room
        if $(event.target).closest('.marker').length>0
            room = Blaze.getData(event.target)
            Session.set 'selection', room._id
        else
            Session.set 'selection', null

    'submit #room-editor': (event, template)->
        event.preventDefault()
        Rooms.update Session.get('selection'), $set: 
            title: $(event.target.title).val()

    'dragend': (event, template)->
        # this is a hack. since the leaflet marker's div element 
        # is not rendered by meteor, it has no associatd data, 
        # we have to get tha data from the contentBlock, by passing the marker's first child
        # to the getData method.
        # This has to be resolved. It wont work with builtin L.Icon-s !!!
        room = Blaze.getData($(event.target).children().get(0))
        Rooms.update room._id, $set:
            latlng: event.latlng

    'click #room-list': (event, template)->
        room = Blaze.getData(event.target)
        Session.set 'selection', room._id

Template.roomList.helpers
    isSelected: ->
        item = Template.currentData()
        selection = Template.parentData(1).selection
        unless item? and selection? then return null
        return item._id is selection._id

    selectedItem: ()->
        options = Template.currentData()
        selectedItem = null
        if options.selection?
            selectedItem = _.where(options.items.fetch(), {_id: options.selection._id})[0]
        return selectedItem