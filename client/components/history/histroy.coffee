Template.changes.onCreated ->
  self = this
  self.autorun ->
    self.subscribe 'history', Template.currentData()._id 


Template.changes.helpers
    changes: ->
        @changes?.slice().reverse() or null

    fields: ->
        _.map _.pairs(_.omit(this, ['date', 'updatedBy'])), (kv)->
            {name: kv[0], value: kv[1]}

