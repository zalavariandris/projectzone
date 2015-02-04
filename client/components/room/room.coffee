Template.room.created = ->
    @disabled = new ReactiveVar null
    @autorun ()=>
        console.log "new data"
        Session.get("selection")
        @disabled.set true
        

Template.room.helpers        
    disabled: ()->
        Template.instance().disabled.get()

    url: (uri)->
        unless uri then return null
        if uri.substring(0,7) is "http://" or uri.substring(0,8) is "https://"
            return uri
        else
            return "http://"+uri

Template.room.events
    'click .edit': (event, template)->
        template.disabled.set false

    'click .cancel': (event, template)->
        template.disabled.set true

    'submit form': (event, template)->
        event.preventDefault()
        template.disabled.set true

    'click .remove': (event, template)->
        if confirm "delete"
            console.log "delete room ", this._id
            Rooms.update this._id, $set:
                deleted: true
            template.disabled.set true




