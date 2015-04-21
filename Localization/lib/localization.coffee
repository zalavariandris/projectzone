@Languages = {}


@Localize = (key)->
    language = Session.get('language')
    return Languages[language][key] or ""+key+""

if Meteor.isClient
    Template.registerHelper 'localize', Localize






