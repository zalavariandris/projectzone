map = {}
markers = {}

Template.mapbox.rendered = ->
    self = this
    # create map
    map = L.mapbox.map self.find(".canvas"), "zalavariandris.jj2aj5cj",
        doubleClickZoom: false
        touchZoom: false

    map.on 'dblclick', (event)->
        event.originalEvent.stopPropagation()
        event.originalEvent.stopImmediatePropagation()
        $.event.trigger {type: "dblclick", latlng: event.latlng}, event.originalEvent, event.originalEvent.target

    # set map view to budapest 
    map.setView [47.50, 19.055], 12

    # We evaluate Template.currentData in an autorun to make sure
    # Blaze.currentView is always set when it runs (rather than
    # passing straight to ObserveSequence).
    argVar = new ReactiveVar(null)
    
    self.autorun ->
        try
            argVar.set Template.currentData().items
        catch error
            debugger

    sequenceFunc = ()->
        return argVar.get()

    views = {}
    ObserveSequence.observe sequenceFunc, 
        addedAt: (id, room)->
            marker = new L.Marker room.latlng,
                _id: room._id
                draggable: true
                clickable: true
                icon: new L.BlazeIcon
                    iconSize: [18, 18]
                    onCreate: (div)->
                        view = Blaze.renderWithData self.view.templateContentBlock, room, div, self.view
                        views[id] = view

            marker.on 'dragstart', (event)->
                marker = event.target
                $.event.trigger {type: "dragstart", latlng: marker.getLatLng()}, event, event.target._icon
            
            marker.on 'drag', (event)->
                marker = event.target
                $.event.trigger {type: "drag", latlng: marker.getLatLng()}, event, event.target._icon
            
            marker.on 'dragend', (event)->
                marker = event.target
                $.event.trigger {type: "dragend", latlng: marker.getLatLng()}, event, event.target._icon
                        

            marker.addTo map            
            markers[id] = marker

        changedAt: (id, room)->
            views[id].dataVar.set room
            markers[id].setLatLng room.latlng

        removedAt: (id, room)->
            marker = markers[id]
            if map.hasLayer marker
                map.removeLayer marker
                delete markers[id]






   