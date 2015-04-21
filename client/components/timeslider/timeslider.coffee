Template.timeslider.helpers
  rooms: ()->
    Rooms.find()

  pos: ()->
    return {
      left: ((this.opened or 1989) - 1989) / (2015-1989) * 100 + "%"
      width: ((this.closed or 2015) - (this.opened or 1989)) / (2015-1989) * 100 + "%"
    }