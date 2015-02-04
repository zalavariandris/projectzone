Template.login.events
    'click .logout': ->
        Meteor.logout()

    'submit #login': (event, template)->
        event.preventDefault()
        Meteor.loginWithPassword event.target.email.value, event.target.password.value, (error)->
            if error then alert error.message

Template.miniLogin.events
    'click .logout': (event, template)->
        console.log "log out!"
        Meteor.logout()

    'submit #login': (event, template)->
        event.preventDefault()
        Meteor.loginWithPassword event.target.email.value, event.target.password.value, (error)->
            if error then alert error.message