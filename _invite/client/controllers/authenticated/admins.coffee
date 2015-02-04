Template.admins.helpers
    users: ()->
        Meteor.users.find()

    email: ()->
        @emails[0].address

    isAdmin: ()->
        console.log "user: ", this
        Roles.userIsInRole this, 'admin'

Template.admins.events
    'click .admin': (event, template)->
        isAdminNow = Roles.userIsInRole this, 'admin'
        Meteor.call 'setAdmin', this, not isAdminNow, (error)->
            if error
                alert error.message
