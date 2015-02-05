Iron.Router.hooks.hideOverlay = ->
    Session.set 'showOverlay', false
    @next()

Iron.Router.hooks.showOverlay = ->
    Session.set 'showOverlay', true
    @next()

Router.onBeforeAction 'hideOverlay',
    only: ['map']
    
Router.onBeforeAction 'showOverlay',
    except: ['map']

Router.route "index",
    path: "/"
    layoutTemplate: 'layoutOverlay'
    template: "blog"
    waitOn: ->
        Meteor.subscribe 'rooms', {'deleted': $exists: false}

Router.route 'map',
    path: '/map'
    layoutTemplate: 'layoutOverlay'
    template: ''
    yieldRegions:
        'logo': to: 'header'
    waitOn: ->
        Meteor.subscribe 'rooms', {'deleted': $exists: false}
        Meteor.subscribe '/invites'

    onBeforeAction: ->
        Session.set 'currentRoute', 'map'
        @next()


