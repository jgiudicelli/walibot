# Description:
#   None
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot beer me - Grab me a beer
#
# Author:
#  jg

cheat = [
  "http://yourteamcheats.com/BUF"
]

module.exports = (robot) ->
  robot.hear /.*(buff|pat).*/i, (msg) ->
    msg.send msg cheat[0]
