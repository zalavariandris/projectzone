Template.registerHelper "selectedItem", ()->
    Rooms.findOne Session.get('selection')

Template.registerHelper "timeRange", ()->
    Session.get 'timeRange'

Template.registerHelper 'isDisabled', ->
    return not Meteor.userId()?

Template.registerHelper 'username', (user)->
    user = if not user?
        Meteor.user()
    else if typeof user is 'string'
        Meteor.users.findOne user
    else if user._id?
        user
        
    user = user or Meteor.user()
    user.username or user.emails[0].address or null


