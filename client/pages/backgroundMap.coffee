Template.backgroundMap.helpers
    rooms: ->
        timeRange = Session.get('timeRange')
        if timeRange then condition = $and: [
            {$or: [{opened: $not: $type: 1}, {opened: $lte: timeRange.end}]},
            {$or: [{closed: $not: $type: 1}, {closed: $gte: timeRange.begin}]},
        ]
        condition['deleted'] = {$exists: false}
        Rooms.find condition

    selectedItem: ->
        Rooms.findOne Session.get('selection')

    isSelected: ->
        item = Template.currentData()
        selection = Rooms.findOne Session.get('selection')

        unless item? and selection? then return null
        return item._id is selection._id

    timeRange: ->
        Session.get 'timeRange'

Template.backgroundMap.created = ->
    Meteor.subscribe 'rooms', {}

Template.backgroundMap.rendered = ()->
    timeRange = Session.get 'timeRange'
    $('#timerange .slider').noUiSlider
        range:
            min: 1989
            max: 2014
        start: [timeRange.begin, timeRange.end]
        connect: true
        step: 1
        margin: 1
        behaviour: "drag"

    $('#timerange .slider').on 'slide', ()->
        Session.set 'timeRange',
            begin: parseInt $(this).val()[0]
            end: parseInt $(this).val()[1]

Meteor.startup ->
    Session.set 'timeRange', {begin: 1989, end: 2014}
    console.log "set timerange"

Template.backgroundMap.events
    ###
    # create rooms by dblclick on the map
    ###
    'dblclick #room-map': (event, template)->
        if Meteor.user()?
            newId = Meteor.call 'room',
                latlng: event.latlng
                title: "-room title-"
            Session.set 'selection', newId

    ###
    # update the room
    # either by dragging on the map to a new location, 
    # or by submitting updates from the sidebar
    ###
    'submit #updateRoom': (event, template)->
        event.preventDefault()
        Rooms.update Session.get('selection'), $set: 
            title: $(event.target.title).val()
            opened: parseInt($(event.target.opened).val()) or null
            closed: parseInt($(event.target.closed).val()) or null
            site: $(event.target.site).val() or ""

    'submit #updateAddress': (event, template)->
        event.preventDefault()
        HTTP.get "http://nominatim.openstreetmap.org/search",
            params:
                q: $(event.target.address).val(),
                format: "json"
            , (error, result)->
                if error
                    alert error.message
                else
                    json = JSON.parse(result.content)[0]
                    latlon = {lat: json.lat, lon: json.lon}
                    Rooms.update Session.get('selection'), $set:
                        latlng: latlon

    'dragend': (event, template)->
        # this is a hack. since the leaflet marker's div element 
        # is not rendered by meteor, it has no associatd data, 
        # we have to get tha data from the contentBlock, by passing the marker's first child
        # to the getData method.
        # This has to be resolved. It wont work with builtin L.Icon-s !!!
        room = Blaze.getData($(event.target).children().get(0))
        Rooms.update room._id, $set:
            latlng: event.latlng

    ### 
    # manage selection, on the map and the list
    ###
    'click #room-map':(event, template)->
        # if the event.target has a ".marker" parent 
        # then the user clicked on a marker, so select the correspondent room
        # otherwise, the user was clicked on the map, so clear the selection
        if $(event.target).closest('.marker').length>0
            room = Blaze.getData(event.target)
            Session.set 'selection', room._id
        else
            Session.set 'selection', null

    'click #room-list': (event, template)->
        room = Blaze.getData(event.target)
        Session.set 'selection', room._id

    ###
    # remove rooms
    ###
    'click #room-editor .delete': (event, template)->
        room = this
        if confirm "delete?" then Rooms.update room._id, $set: deleted: Date.now()



