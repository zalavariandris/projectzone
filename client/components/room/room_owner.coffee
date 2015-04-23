Template.room_owner.helpers
  settings: ->
    {
      position: 'bottom',
      limit: 5
      rules:[
        {
          collection: Meteor.users
          field: "emails.address"
          template: Template.userPill
        }
      ]
    }

  owner: ->
      Meteor.users.findOne(@owner)?.emails[0].address or "noone"

  isOwner: ->
    this.owner is Meteor.userId() or Roles.userIsInRole Meteor.userId(), 'admin'

Template.room_owner.events
  "autocompleteselect input": (event, template, doc)->
    event.target.value = doc.emails[0].address

  "submit": (event, template)->
    event.preventDefault()
    room = this
    toUser = Meteor.users.findOne({'emails.address': event.target.email.value})
    
    if confirm "Átruházod rá: #{event.target.email.value}?"
      Meteor.call 'transferOwnership', room, toUser, (error)->
        if error
          alert error.message
        else
          event.target.reset()

Template.userPill.helpers
  email: ()->
    @emails[0].address