Template.login_page.events
    'submit': ->
        Tracker.autorun ->
            unless Meteor.loggingIn()
                if Meteor.user() then Router.go("/map") else @stop
