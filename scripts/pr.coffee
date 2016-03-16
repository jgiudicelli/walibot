# Description:
# get pr's that are ready for deployment
#
# Commands
# hubot reset msg interval <seconds> - reset the interval at which we check PRs
#

gtoken = process.env.HUBOT_TOKEN
room = process.env.HUBOT_HIPCHAT_ROOMS
url = "https://api.github.com/repos/Liaison-Intl/WebAdMIT/issues?labels=Ready%20for%20Release%20Master"
interval = 1000 * 60 * 30 # msec

module.exports = (robot) ->
  BUSINESS_DAY_NAMES = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
  setInterval () ->
    now = new Date()
    day = now.getDay() - 1
    hour = now.getHours()
    if BUSINESS_DAY_NAMES[day] && hour >= 13 && hour <= 19
      robot.http(url)
        .header('Accept', 'application/json')
        .header('Authorization', "token #{gtoken}")
        .get() (err, res, body) ->
          if err
            console.log "#{err} #{body}"
          else
            data = JSON.parse(body)
            prs = data.map (pr) -> pr.html_url
            if prs?.length > 0
              handles = robot.brain.get('handles')
              resp = prs.toString()
              robot.messageRoom room, "#{handles} #{resp}"
  , interval

  # robot.respond /reset msg interval (\d+)/i, (msg) ->
  #   new_interval = msg.match[1]
  #   handles = robot.brain.get('handles')
  #   user = '@'+msg.message.user.mention_name
  #   if user in handles
  #     interval = 1000 * new_interval
  #     msg.reply 'updated interval to ' + new_interval + ' seconds'
