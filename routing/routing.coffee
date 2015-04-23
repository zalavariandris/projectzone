
Router.onBeforeAction ()->
  Session.set 'showOverlay', false
  @next()
, only: ['map']
  
Router.onBeforeAction ()->
  Session.set 'showOverlay', true
  @next()
, except: ['map']

Router.route "blog",
  path: "/"
  layoutTemplate: 'layoutOverlay'
  template: "blog"

  # waitOn: ->
  #     Meteor.subscribe 'rooms', {'deleted': $exists: false}

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


