Template.roomPermissions.helpers
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
                callback: (selected)->
                    input = self.find("[name=email]")
                    $(input).val(selected.emails[0].address)
            ]
        }

    owner: ->
        Meteor.users.findOne(@owner).emails[0].address

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

Template.userPill.helpers

    'email': ->
        this.emails[0].address

