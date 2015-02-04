Template.requestInvitation.events
    'submit form': (e)->
        e.preventDefault()
        invitee = 
            email: $(e.target.email).val().toLowerCase()
            invited: false
            requested: ( new Date() ).getTime()

        Meteor.call 'addToInvitesList', invitee, (error, response)->
            if error
                alert error.reason
            else
                alert "Invite requested. We'll be in touch soon. Thanks for your interest in Projectzone!"