Template.login.events
    'click .logout': ->
        Meteor.logout()

    'submit #login': (event, template)->
        event.preventDefault()
        Meteor.loginWithPassword event.target.email.value, event.target.password.value, (error)->
            if error then alert error.message
            else Router.go "/map"

