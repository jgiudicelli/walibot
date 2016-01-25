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
#   None
#
# Author:
#  jg

cheat = [
  "http://yourteamcheats.com/BUF"
]

module.exports = (robot) ->
  robot.hear /.*(buff|pat).*/i, (msg) ->
    msg.send cheat[0]
