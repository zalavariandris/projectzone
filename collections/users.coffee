# if Meteor.isServer
#     andris = Meteor.users.findOne({
#         'emails.address': "zalavariandris@gmail.com",
#         'username': "andris"
#     })
#     unless andris
#         Accounts.createUser username: "andris", email: "zalavariandris@gmail.com", password: "bab"