
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

Template.swapOwner.onRendered ->
  Meteor.typeahead @find('#transfereOwnership [name=email]')

Template.shareEdit.onRendered ->
  Meteor.typeahead @find('#share [name=email]')

Template.swapOwner.helpers
    emails: ->
        owner = Template.currentData().owner
        emails = _.compact _.map Meteor.users.find('_id': $not: owner).fetch(), (user)->
            return user?.emails?[0].address or null

        return emails

Template.shareEdit.helpers
    emails: ->
        editors = Template.currentData().canEdit or []
        emails = _.compact _.map Meteor.users.find('_id': $nin: editors).fetch(), (user)->
            return user?.emails?[0].address or null
        console.log emails
        return emails
