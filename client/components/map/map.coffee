Template.map.helpers
    rooms: ->
        timeRange = Session.get('timeRange')
        condition = {}
        if timeRange then condition = $and: [
            {$or: [{opened: $not: $type: 1}, {opened: $lte: timeRange.end}]},
            {$or: [{closed: $not: $type: 1}, {closed: $gte: timeRange.begin}]},
        ]
        condition['deleted'] = {$exists: false}
        return Rooms.find(condition).fetch()

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
    ###
    # create rooms by dblclick on the map
    ###
    # 'dblclick': (event, template)->
    #     if Meteor.user()?
    #         newId = Rooms.insert
    #             latlng: {lat: event.latlng.lat, lng: event.latlng.lng}
    #             title: "-new space-"
    #         Session.set 'selection', newId

    'dragend': (event, template)->
        # this is a hack. since the leaflet marker's div element 
        # is not rendered by meteor, it has no associatd data, 
        # we have to get tha data from the contentBlock, by passing the marker's first child
        # to the getData method.
        # This has to be resolved. It wont work with builtin L.Icon-s !!!
        room = Blaze.getData($(event.target).children().get(0))
        Rooms.update room._id, $set:
            latlng: lat: event.latlng.lat, lng: event.latlng.lng

    'click':(event, template)->
        # if the event.target has a ".marker" parent 
        # then the user clicked on a marker, so select the correspondent room
        # otherwise, the user was clicked on the map, so clear the selection
        switch Session.get('tool')
            when 'marker'
                newId = Rooms.insert
                    latlng: {lat: event.latlng.lat, lng: event.latlng.lng}
                    title: "-new space-"

                Session.set 'tool', null
                Session.set 'selection', newId
            else
                if $(event.target).closest('.marker').length>0
                    room = Blaze.getData(event.target)
                    Session.set 'selection', room._id
                else
                    Session.set 'selection', null
