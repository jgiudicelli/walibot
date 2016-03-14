# Description:
#   Manage your release masters. release masters get stored in the robot brain.
#
# Dependencies:
#   "xml2js": "0.1.14"
#
# Configuration:
#
# Commands:
#   hubot add release master <hipchat handle> - add release master hipchat handle to the robot brain
#   hubot list release master - List all of the release masters that are being tracked
#   hubot remove release master <hipchat handle> - remove the hipchat handle
#
# Author
#   jg based on bookmark.coffee by mm53bar

module.exports = (robot) ->

  robot.respond /add release master (.+)/i, (msg) ->
    if msg.message.user.mention_name.match(/therealJG/i)
      handle = msg.match[1].replace /^\s+|\s+$/g, ""
      link = new Handle robot

      link.add handle, (err, message) ->
        if err?
          msg.reply "I have a vague memory of hearing about that handle sometime in the past."
        else
          msg.reply "I've stuck that handle into my robot brain." 
    else
      msg.reply '(poo)'

  robot.respond /list release master/i, (msg) ->
    handle = new Handle robot

    handle.list (err, message) ->
      if err?
        msg.reply "Handles? What handles? I don't remember any handles."
      else
        msg.reply message

  robot.respond /remove release master (.+)/i, (msg) ->
    if msg.message.user.mention_name.match(/therealJG/i)
      handle = msg.match[1].replace /^\s+|\s+$/g, ""
      link = new Handle robot

      link.remove handle, (err, message) ->
        if err?
          console.log "#{err}"
        else
          msg.reply message
    else
      msg.reply '(poo)'

# Classes

class Handle
  constructor: (robot) ->
    robot.brain.data.handles ?= []
    @handles_ = robot.brain.get('handles')

  all: (handle) ->
    if handle
      @handles_.push handle
    else
      @handles_

  add: (handle, callback) ->
    if handle in @all()
      callback "handle already exists"
    else
      @all handle
      callback null, "handle added"

  list: (callback) ->
    if @all().length > 0
      resp_str = "These are the handles I'm remembering:\n\n"
      for handle in @all()
        if handle
          resp_str += handle
      callback null, resp_str
    else
      callback "No handles exist"

  remove: (handle, callback) ->
    if handle
      try
        empt = []
        newArr = @handles_.filter (word) -> word isnt handle
        robot.brain.set 'handles', newArr
        @handles_ = newArr
        callback null, "deleted"
      catch error
        callback error, null
    else
      callback "No results found"

