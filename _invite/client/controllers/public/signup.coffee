Template.signup.helpers
    betaToken: ->
        Session.get 'betaToken'

Template.signup.events
    'submit form': (e, t)->
        e.preventDefault()

        user = 
            email: $(e.target.email).val()
            password: $(e.target.password).val()
            betaToken: $(e.target.betaToken).val()


        Meteor.call 'validateBetaToken', user, (error)->
            if error
                alert error.reason
            else
                Meteor.loginWithPassword user.email, user.password, (error)->
                    if error
                        alert error.reason
                    else
                        Router.go "/map"