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
    dblclick: (event, template, latlng)->
        Rooms.insert
            latlng: event.latlng
            title: "-room title-"
        # console.log 'event: ', event

    'submit #room-editor': (event, template)->
        event.preventDefault()
        Rooms.update Session.get('selection'), $set: 
            title: $(event.target.title).val()

    'click #room-list': (event, template)->
        try
            Session.set 'selection', Blaze.getData(event.target)._id
        catch error

    # 'click #room-map': (event, template)->
    #     debugger

# roomList
# Template.roomList.created = ->
#     selection = new ReactiveVar()
#     selection.set null

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

Template.roomList.events
    'click ul': (event, template)->
        try
            Session.set 'selection', Blaze.getData(event.target)._id
        catch error
            debugger