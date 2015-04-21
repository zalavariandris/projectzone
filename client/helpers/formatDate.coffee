Template.registerHelper 'formatDate', (date)->
    return moment(date).format("MM-DD-YYYY")

Template.registerHelper 'fromNow', (date)->
    return moment(date).fromNow()