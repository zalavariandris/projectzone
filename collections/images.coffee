@Images = new FS.Collection "images",
  stores: [new FS.Store.GridFS "images"]
  chunkSize: 1024*1024*0.1

Images.allow
  insert: (userId, doc)->
    userId?

  update: (userId, doc)->
    userId?

  remove: (userId, doc)->
    userId?

  download: (userId, doc)->
    true