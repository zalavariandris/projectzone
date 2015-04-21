Template.registerHelper 'username': (user)->
    user = if typeof user is 'string'
        Meteor.users.findOne(user)
    else if user._id?
        user
    else
        null

    console.log user
    return user?.emails[0].address or "-no user-"