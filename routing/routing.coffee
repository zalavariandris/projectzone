Router.map ->
    this.route 'map',
        path: "/"
        layoutTemplate: "layout"
        template: "map"
        waitOn: ->
            Meteor.subscribe 'rooms', {}

    this.route 'login',
        layoutTemplate: "layout"
        template: "map"
        waitOn: ->
            Meteor.subscribe 'rooms', {}
        yieldTemplates:
            'login': to: "modal"

    this.route 'leaflet'

Router.map ->
    this.route 'maponly',
        path: "/maponly"
        layoutTemplate: "layout2"
        template: "projectZoneLogo"

    this.route 'originalSite',
        path: "/originalsite"
        layoutTemplate: "layout2"
        template: "originalSite"

    this.route 'login2',
        path: "/login2"
        layoutTemplate: "layout2"
        template: "login"