Template.map.helpers
    rooms: ->
        timeRange = Session.get('timeRange')
        condition = {}
        if timeRange then condition = $and: [
            {$or: [{opened: $not: $type: 1}, {opened: $lte: timeRange.end}]},
            {$or: [{closed: $not: $type: 1}, {closed: $gte: timeRange.begin}]},
        ]
        condition['deleted'] = {$exists: false}

        rooms = Rooms.find(condition).fetch()
        return _.map rooms, (room)->
            isSelected = room._id is Session.get('selection')
            room.draggable = isSelected
            return room

    isSelected: ->
        item = Template.currentData()
        selection = Rooms.findOne Session.get('selection')

        unless item? and selection? then return null
        return item._id is selection._id

    
    klass: ()->
        if Session.get('tool') is 'marker'
            return "cover crosshair"
        else
            return "cover"


Template.map.events
    'click .leaflet-marker-icon': (event, template)->
        console.log 'click icon'
        switch Session.get('tool')
            when 'marker'
                event.stopPropagation()
            else
                event.stopPropagation()
                room = Blaze.getData(event.target)
                Session.set 'selection', room._id

    'click .map-container': (event, template)->
        event.stopPropagation()

        console.log "click container", event.latlng

        switch Session.get('tool')
            when 'marker'
                newId = Rooms.insert
                    latlng: {lat: event.latlng.lat, lng: event.latlng.lng}
                    title: "-new space-"

                Session.set 'tool', null
                Session.set 'selection', newId
            else
                Session.set('selection', null)

        
    'dragend': (event, template)->
        # this is a hack. since the leaflet marker's div element 
        # is not rendered by meteor, it has no associatd data, 
        # we have to get tha data from the contentBlock, by passing the marker's first child
        # to the getData method.
        # This has to be resolved. It wont work with builtin L.Icon-s !!!
        room = Blaze.getData($(event.target).children().get(0))
        Rooms.update room._id, $set:
            latlng: lat: event.latlng.lat, lng: event.latlng.lng

