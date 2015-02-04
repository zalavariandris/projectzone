Router.route "index",
    path: "/"
    waitOn: ->
        Meteor.subscribe 'rooms', {'deleted': $exists: false}

    action: ->
        @layout "layout"
        @render "blog_page"

Router.route "/map",
    waitOn: ->
        Meteor.subscribe 'rooms', {'deleted': $exists: false}
        Meteor.subscribe '/invites'
        
    action: ()->
        @layout "layout"
        @render "map_page"

# Router.route 'map',
#     path: '/map'
#     layoutTemplate: 'layoutOverlay'
#     template: 'map'
#     onBeforeAction: ->
#         Session.set 'currentRoute', 'map'
#         @next()

# Router.route "/login",
#     action: ()->
#         @layout "layout"
#         @render "login_page"

