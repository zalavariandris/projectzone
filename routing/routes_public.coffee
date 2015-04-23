

Router.route 'register',
  path: "/request"
  layoutTemplate: 'layoutOverlay'
  template: "requestInvitation"
  onBeforeAction: ->
    Session.set 'currentRoute', 'index'
    @next()

Router.route 'signup',
  path: '/signup'
  layoutTemplate: 'layoutOverlay'
  template: 'signup'
  onBeforeAction: ->
    Session.set 'currentRoute', 'signup'
    Session.set 'betaToken', ''
    @next()

Router.route 'signup/:token',
  path: '/signup/:token'
  layoutTemplate: 'layoutOverlay'
  template: 'signup'
  onBeforeAction: ->
    Session.set 'currentRoute', 'signup'
    Session.set 'betaToken', @params.token
    @next()

Router.route 'login',
  path: '/login'
  layoutTemplate: 'layoutOverlay'
  template: 'login'
  onBeforeAction: ->
    Session.set 'currentRoute', 'login'
    @next()

Router.route 'room',
  path: '/room/:_id'
  layoutTemplate: 'layoutOverlay'
  template: 'room'
  onBeforeAction: ->
    Session.set 'currentRoute', 'room'
    @next()

  waitOn: -> 
    [Meteor.subscribe('rooms', @params._id)]

  data: ->
    Rooms.findOne @params._id