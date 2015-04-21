Template.layoutOverlay.helpers
  showOverlay: (align)->
    Session.get('showOverlay')

  isBlog: ()->
    Router.current().route.getName() is "blog"