Template.timerange.rendered = ()->
    timeRange = Session.get 'timeRange'

    this.$('.slider').noUiSlider
        animate: false
        range:
            min: 1989
            max: 2014
        start: [1989, 2014]
        connect: true
        step: 1
        margin: 1
        behaviour: "drag"

    # update slider when timeRange changes
    this.autorun =>
        tr = Session.get('timeRange')
        if tr then this.$('.slider').val([tr.begin, tr.end])
    

Template.timerange.events
    'slide .slider': (event, template)->
        range = template.$(".slider").val()
        Session.set 'timeRange', {begin: Math.floor(range[0]), end: Math.floor(range[1])}
