Router.route 'dashboard',
    path: '/dashboard'
    layoutTemplate: 'layout'
    template: 'dashboard'
    onBeforeAction: ->
        Session.set 'currentRoute', 'dashboard'
        @next()

Router.route 'invites',
    path: '/invites'
    layoutTemplate: 'layoutOverlay'
    template: 'invites'
    waitOn: ->
        Meteor.subscribe '/invites'

    onBeforeAction: ->
        Session.set 'currentRoute', 'invites'
        @next()

Router.route 'admins',
    path: '/admins'
    layoutTemplate: 'layoutOverlay'
    template: 'admins'

    waitOn: ->
        Meteor.subscribe 'users', {}
        
    onBeforeAction: ->
        Session.set 'currentRoute', 'admins'
        @next()

Router.route 'roomPermissions',
    path: '/room/:_id'
    layoutTemplate: 'layoutOverlay'
    template: 'roomPermissions'

    waitOn: ->
        Meteor.subscribe 'rooms', @params._id
        Meteor.subscribe 'users', {}

    data: ->
        Rooms.findOne @params._id

