# Epoch to String
# Return a formatted date string for a given unix/epoch timestamp.

UI.registerHelper('epochToString', (timestamp) ->
    moment.unix(timestamp / 1000).format("MMMM Do, YYYY")
)