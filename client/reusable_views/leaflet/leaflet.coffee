@App = {}
Template.leaflet.rendered = ->
    self = this
    map = {}
    markers = {}
    views = {}

    ###
    # tile PROVIDERS
    # http://leaflet-extras.github.io/leaflet-providers/preview/index.html
    ###
    
    Stamen_TonerLite = L.tileLayer 'http://{s}.tile.stamen.com/toner-lite/{z}/{x}/{y}.png', 
        attribution: 'Map tiles by <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>'
        subdomains: 'abcd'


    map = new L.Map self.firstNode,
        layers: [Stamen_TonerLite]
        doubleClickZoom: false
        touchZoom: false
        center: L.latLng(47.50, 19.055)
        zoom: 13
        minZoom: 12
        maxZoom: 16
        maxBounds: L.latLngBounds L.latLng(47.42669366522116, 18.921890258789062), L.latLng(47.573283112482144, 19.188308715820312)

    App.map = map
    self.autorun ->
        options =  Template.currentData()
        for id, marker of markers
            if options.disabled then marker.dragging.disable() else marker.dragging.enable()

    map.on 'dblclick', (event)->
        event.originalEvent.stopPropagation()
        event.originalEvent.stopImmediatePropagation()
        $.event.trigger {type: "dblclick", latlng: event.latlng}, event.originalEvent, event.originalEvent.target


    # set map view to budapest 
    # map.setView , 13

    # southWest = 
    # northEast = 
    # bounds = L.latLngBounds(southWest, northEast)
    # map.setMaxBounds bounds

    # We evaluate Template.currentData in an autorun to make sure
    # Blaze.currentView is always set when it runs (rather than
    # passing straight to ObserveSequence).
    argVar = new ReactiveVar(null)

    self.autorun ->
        argVar.set Template.currentData().items

    sequenceFunc = ->
        argVar.get()

    ObserveSequence.observe sequenceFunc,
        addedAt: (id, room)->
            unless room.latlng then return
            marker = new L.Marker room.latlng,
                _id: room._id
                draggable: not Blaze.getData(self.view).disabled
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

