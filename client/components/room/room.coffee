
###
# ROOM
###

# coverImage



Template.room.onCreated ->
  self = this
  
  self.autorun ->
    self.subscribe 'images', Template.currentData().coverImage

Template.room.helpers
  url: ()->
    Images.findOne(@coverImage)?.url() or null

# owner

Template.room.onCreated ->
  self = this
  self.autorun ->
    self.subscribe "users"

Template.room.helpers
  canEdit: ->
        Permissions.canEdit(this)
        
  isOwner: ->
      this.owner is Meteor.userId() or Roles.userIsInRole Meteor.userId(), 'admin'

  owner: ->
      Meteor.users.findOne(@owner)?.emails[0].address or "noone"

  editors: ->
      Meteor.users.find _id: $in: (this.canEdit or [])


Template.room.events
  'click .revoke': (event, template)->
    room = Template.currentData()
    fromUser = this
    if confirm "Visszavonod?"
      Meteor.call "revokeShare", room, fromUser, (error)->
        if error then alert error.message
###
# ROOM
###
Template.asset.helpers
  uploaded: ()->
    Images.findOne(@coverImage)?.isUploaded()

  progress: ()->
    Images.findOne(@coverImage)?.uploadProgress() or null

Template.asset.events
  'change [type=file]': (event, template)->
    file = event.target.files[0]

    room = this
    file = Images.insert file, (error, fileObj)->
      if error
        alert error.message

    Rooms.update room._id, $set:
      coverImage: file._id

  'click .delete': (event, template)->
    Rooms.update this._id, $unset:
      coverImage: null
    , (error)->
      if error
        alert error.message
      else
        Images.remove this.coverImage

# Swap Owner
Template.swapOwner.onRendered ->
  Meteor.typeahead @find('#transferOwnership [name=email]')

Template.swapOwner.helpers
  emails: ->
    owner = Template.currentData().owner
    emails = _.compact _.map Meteor.users.find('_id': $not: owner).fetch(), (user)->
        return user?.emails?[0].address or null
    return emails

Template.swapOwner.events
  'submit #transferOwnership': (event, template)->
    event.preventDefault()
    room = this
    toUser = Meteor.users.findOne({'emails.address': event.target.email.value})
    
    if confirm "Átruházod rá: #{event.target.email.value}?"
      Meteor.call 'transferOwnership', room, toUser, (error)->
        if error then alert error.message
        else event.target.reset()

# Share Edit
# Template.shareEdit.onRendered ->
#   Meteor.typeahead @find('#share [name=email]')

# Template.shareEdit.helpers
#   emails: ->
#     editors = Template.currentData().canEdit or []
#     emails = _.compact _.map Meteor.users.find('_id': $nin: editors).fetch(), (user)->
#         return user?.emails?[0].address or null

#     return emails

# Template.shareEdit.events
#   'submit #share': (event, template)->
#     event.preventDefault()
#     room = Template.currentData()
#     withUser = Meteor.users.findOne 'emails.address': event.target.email.value
    
#     if confirm "Megosztod vele: #{withUser.emails[0].address}?"
#       Meteor.call 'shareWith', room, withUser, (error)->
#         if error then alert error.message
#         else event.target.reset()
