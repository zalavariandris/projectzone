Meteor.methods(
  addToInvitesList: (invitee) ->
    check(invitee, {email: String, requested: Number, invited: Boolean})

    emailExists = Invites.findOne({"email": invitee.email})

    if emailExists
      throw new Meteor.Error "email-exists", "It looks like youve already signed up for our beta. Thanks!"
    else
      inviteCount = Invites.find({},{fields: {"_id": 1}}).count()
      invitee.inviteNumber = inviteCount + 1

      Invites.insert(invitee, (error)->
        console.log error if error
      )
)