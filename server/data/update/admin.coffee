Meteor.methods
  setAdmin: (user, value)->
    console.log user, value
    Webmaster = Roles.userIsInRole(this.userId, 'webmaster')
    if not Webmaster
      throw new Meteor.Error "no permision", "only the webmaster has the permission to change user roles"
    else
      if value is true
        Roles.addUsersToRoles user, 'admin'
      else if value is false
        roles = Roles.getRolesForUser user
        roles.splice roles.indexOf('admin'), 1
        Roles.setUserRoles user, roles
