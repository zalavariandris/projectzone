Template.controls.helpers
    'isAdmin': ()->
        Roles.userIsInRole(Meteor.user(), 'admin')

    'isWebmaster': ()->
        Roles.userIsInRole(Meteor.user(), 'webmaster')

    'newRequestsCount': ()->
        Invites.find({invited: false}).count()