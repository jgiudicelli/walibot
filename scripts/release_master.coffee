# Description:
#   Manage your links. Links get stored in the robot brain.
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

  robot.respond /add release master (@\S+)/i, (msg) ->
    handle = msg.match[1]
    link = new Handle robot

    link.add handle, (err, message) ->
      if err?
        msg.reply "I have a vague memory of hearing about that handle sometime in the past."
      else
        msg.reply "I've stuck that handle into my robot brain." 

  robot.respond /list release master/i, (msg) ->
    handle = new Handle robot

    handle.list (err, message) ->
      if err?
        msg.reply "Links? What links? I don't remember any links."
      else
        msg.reply message

  robot.respond /remove release master (@\S+)/i, (msg) ->
    handle = msg.match[1]
    link = new Handle robot

    link.remove handle, (err, message) ->
      if err?
        console.log "#{err}"

# Classes

class Handle
  constructor: (robot) ->
    robot.brain.data.handle ?= []
    @handle_ = robot.brain.data.handle

  add: (handle, callback) ->
    result = []
    @all().forEach (entry) ->
      if entry
        result.push handle
    if result.length > 0
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
      obsolete = handle
      handle.delete
      callback null, "deleted " + obsolete
    else
      callback "No results found"

