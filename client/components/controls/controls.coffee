Template.controls.helpers
    'isAdmin': ()->
        Roles.userIsInRole(Meteor.user(), 'admin')

    'isWebmaster': ()->
        Roles.userIsInRole(Meteor.user(), 'webmaster')

    'newRequestsCount': ()->
        Invites.find({invited: false}).count()


Template.controls.helpers
    languages: ()->
        return ['en', 'hu']

    isLanguageSelected: ()->
        language = this.valueOf()
        return language is Session.get('language')

Template.controls.events
    'change [name=language]': (event, template)->
        Session.set 'language', event.target.value

