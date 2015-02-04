@animateTimeRange = (from, to)->
    Session.set "timeRange", {begin: from, end: from}

    animation = Meteor.setInterval ()->
        tr = Session.get "timeRange"
        unless tr.end >= to
            console.log "inc timerange"
            tr.end++
            Session.set 'timeRange', tr
        else
            Meteor.clearInterval animation
    , 300/(to-from)
    return undefined

Template.map_page.rendered = ->
    this.autorun ->
        unless Session.get('timeRange')
            animateTimeRange(1989, 2014)