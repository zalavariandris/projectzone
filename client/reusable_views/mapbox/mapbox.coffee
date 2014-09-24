map = {}
markers = {}
# createIcon = (options={}, selected=false)->
#     return new L.BlazeIcon
#         iconSize: [18, 18]
#         onCreate: (div)->
#             view = Blaze.render Template._blazeIcon, div



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
                        # view = Blaze.renderWithData Template._blazeIcon, room, div
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

    # self.autorun ->
    #     options = Blaze.getData(self.view)
    #     if options.selection?._id?
    #         for id, marker of markers
    #             marker.setIcon new L.BlazeIcon
    #                 iconSize: [18, 18]
    #                 onCreate: (div)->
    #                     view = Blaze.renderWithData self.view.templateContentBlock, room, div
    #                     # view = Blaze.renderWithData Template._blazeIcon, room, div
    #                     views[id] = view

# Template.mapbox.created = ->
#     self = this







   