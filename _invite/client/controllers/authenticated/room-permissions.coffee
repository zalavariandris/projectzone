# Template.roomPermissions.rendered = ->
#     ownerInput = @find('#transfereOwnership input[type=email]')
#     console.log ownerInput
#     Meteor.typeahead ownerInput, (query, callback)->
#         users = Meteor.users.find('emails.address': new RegExp query, "i").fetch()
#         emails = _.map users, (user)->
#             return user.emails[0].address
#         Meteor.setTimeout ()->
#             debugger
#         , 10
#         callback(users)

Template.roomPermissions.rendered = ->
    Meteor.typeahead @find('#transfereOwnership [name=email]')
    Meteor.typeahead @find('#share [name=email]')



Template.roomPermissions.helpers
    emails: ->
        emails = _.map Meteor.users.find().fetch(), (user)->
            return user.emails[0].address
        return emails

    auto: ->
        self = Template.instance()
        return {
            position: 'bottom'
            limit: 5
            rules: [
                template: Template.userPill
                token: ""
                collection: Meteor.users
                field: 'emails.address'
                callback: (data, input)->
                    $(input).val(data.emails[0].address)

            ]
        }

    owner: ->
        Meteor.users.findOne(@owner)?.emails[0].address or "noone"

    editors: ->
        Meteor.users.find _id: $in: (this.canEdit or [])

Template.roomPermissions.events
    'submit #transfereOwnership': (event, template)->
        event.preventDefault()
        room = this
        toUser = Meteor.users.findOne({'emails.address': event.target.email.value})
        
        if confirm "transfere ownership to: #{event.target.email.value}"
            Meteor.call 'transfereOwnership', room, toUser, (error)->
                if error then alert error.message
                else event.target.reset()
                
    'submit #share': (event, template)->
        event.preventDefault()
        room = Template.currentData()
        withUser = Meteor.users.findOne 'emails.address': event.target.email.value
        
        if confirm "share with user: #{withUser.emails[0].address}"
            Meteor.call 'shareWith', room, withUser, (error)->
                if error then alert error.message
                else event.target.reset()

    'click .revoke': (event, template)->
        room = Template.currentData()
        fromUser = this
        if confirm "revoke?"
            Meteor.call "revokeShare", room, fromUser, (error)->
                if error then alert error.message

Template.userPill.helpers
    'email': ->
        this?.emails[0].address



