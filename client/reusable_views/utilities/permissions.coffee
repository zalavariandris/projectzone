Template.registerHelper 'isDisabled', ->
    return not Meteor.userId()?