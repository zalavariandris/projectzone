Template.tools.events
    'click .marker': (event, template)->
        if Session.get 'tool', "marker"
            Session.set 'tool', null
        else
            Session.set 'tool', "marker"


Template.tools.helpers
    'markerActive': (event, template)->
        Session.get('tool') is "marker"

Template.tools.events
    'keydown': (event, template)->
        if event.keyCode is 27 then Session.set 'tool', null

