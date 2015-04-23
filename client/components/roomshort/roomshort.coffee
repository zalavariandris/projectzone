Template.roomShort.onCreated ->
  @disabled = new ReactiveVar null
  @autorun ()=>
    console.log "new data"
    Session.get("selection")
    @disabled.set true

Template.roomShort.helpers        
  disabled: ()->
    Template.instance().disabled.get()

Template.roomShort.events
  'edit': (event, template)->
    template.disabled.set false

  'updated, cancelled': (event, template)->
    template.disabled.set true

Template.roomShort_show.events
  'click .edit': (event, template)->
    $(event.target).trigger('edit')

Template.roomShort_show.helpers
  formatUrl: (uri)->
    unless uri then return null
    if uri.substring(0,7) is "http://" or uri.substring(0,8) is "https://"
      return uri
    else
      return "http://"+uri

Template.roomShort_edit.helpers
  options: ()->
    RoomSchema.schema().type.allowedValues

  isSelected: ()->
    option = if _.isString(this) then this.valueOf() else null

    if option?
      Template.parentData().type is option
    else
      return not @type?

Template.roomShort_edit.events
  'click .cancel': (event)->
    $(event.target).trigger('cancelled')

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
        $(event.target).trigger('updated')

  'click .remove': (event, template)->
    if confirm "delete"
      console.log "delete room ", this._id
      Rooms.update this._id, $set:
        deleted: true
      template.disabled.set true




