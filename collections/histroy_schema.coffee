UpdateSchema = new SimpleSchema
  # 'createdAt':
  #   type: Date
  #   denyUpdate: true
  #   autoValue: ()->
  #     if @isInsert
  #       return new Date
  #     else if @isupsert
  #       return {$setOnInsert: new Date}
  #     else
  #       @unset()

  'date':
    type: Date
    denyInsert: true
    optional: true
    autoValue: ->
      if @isUpdate then return new Date

  'updateBy':
    type: String
    autoValue: ->
      if @isUpdate then @userId
