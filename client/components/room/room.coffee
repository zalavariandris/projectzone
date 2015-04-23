Template.room.onCreated ->
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

    isAdmin: ()->
        Roles.userIsInRole Meteor.user(), 'admin'

    options: ()->
        RoomSchema.schema().type.allowedValues

    isSelected: ()->
        option = if _.isString(this) then this.valueOf() else null

        if option?
            isEqual = Template.parentData().type is option
            console.group('option')
            console.log "type: ", Template.parentData().type
            console.log "option: ", option
            console.log "isEqual: ", isEqual
            console.groupEnd()
            return isEqual
        else
            return not @type?


Template.room.events
    'click .edit': (event, template)->
        template.disabled.set false

    'click .cancel': (event, template)->
        template.disabled.set true

    'submit form': (event, template)->
        debugger

    'submit form': (event, template)->
        event.preventDefault()
        Rooms.update @_id, $set:
            title: event.target.title.value or undefined
            type: event.target.type.value or undefined
            opened: event.target.opened.value or undefined
            closed: event.target.closed.value or undefined
            site: event.target.site.value or undefined
        , (error)->
            if error
                alert error.message
            else
                template.disabled.set true

    'click .remove': (event, template)->
        if confirm "delete"
            console.log "delete room ", this._id
            Rooms.update this._id, $set:
                deleted: true
            template.disabled.set true




