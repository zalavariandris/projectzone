Meteor.methods(
  sendInvite: (invitee,url) ->
    check(invitee,{id: String, email: String})
    check(url,String)

    token = Random.hexString(10)

    Invites.update(invitee.id,
      $set:
        token: token
        dateInvited: ( new Date() ).getTime()
        invited: true
        accountCreated: false
    ,(error)->
      if error
        console.log error
      else
        Email.send
          to: invitee.email
          from: "Projectzone <projectzone@gmail.com>"
          subject: "Welcome to Projectzone"
          html: "You've been invited to the Projectzone beta. To get started, click the link below to create your account.<br>
          <a href='#{url+token}'>#{url}/#{token}</a>"
    )
)