Template.login.events
    'click .logout': ->
        Meteor.logout()

    'submit #login': (event, template)->
        event.preventDefault()
        Meteor.loginWithPassword event.target.email.value, event.target.password.value, (error)->
            if error then alert error.message
            else Router.go 'map'

    'submit #signup': (event, template)->
        event.preventDefault()
        if event.target.password.value isnt event.target.password2.value
            alert "passwords don't match"
            return

        Accounts.createUser
            email: $(event.target.email).val()
            password: $(event.target.password).val()
        , (error)->
            if error then alert error.message
            else Router.go 'map'

Template.miniLogin.events
    'click .logout': (event, template)->
        Meteor.logout()