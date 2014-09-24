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
        console.log "dblclick on map"
        $.event.trigger {type: "dblclick", latlng: event.latlng}, event.originalEvent, event.originalEvent.target

    # set map view to budapest 
    map.setView [47.50, 19.045], 13

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
                icon: new L.BlazeIcon
                    iconSize: [18, 18]
                    onCreate: (div)->
                        view = Blaze.renderWithData self.view.templateContentBlock, room, div, self.view
                        views[id] = view
                        

            marker.addTo map            
            markers[id] = marker

        changedAt: (id, room)->
            views[id].dataVar.set room

        removedAt: (id, room)->
            marker = markers[id]
            if map.hasLayer marker
                map.removeLayer marker
                delete markers[id]






   