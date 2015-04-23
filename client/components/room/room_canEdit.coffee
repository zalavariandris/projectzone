Template.room_canEdit.helpers
  settings: ->
    {
      position: 'bottom',
      limit: 5
      rules: [
        {
          collection: Meteor.users
          field: "emails.address"
          template: Template.userPill
        }
      ]
    }

  editors: ->
    editors = Meteor.users.find _id: $in: (this.canEdit or [])
    console.log "editors: ", editors.fetch()
    return editors

Template.room_canEdit.events
  "autocompleteselect input[name=email]": (event, template, doc)->
    event.target.value = doc.emails[0].address

  'submit': (event, template)->
    event.preventDefault()
    room = Template.currentData()
    withUser = Meteor.users.findOne 'emails.address': event.target.email.value
    
    if confirm "Megosztod vele: #{withUser.emails[0].address}?"
      Meteor.call 'shareWith', room, withUser, (error)->
        if error then alert error.message
        else event.target.reset()
