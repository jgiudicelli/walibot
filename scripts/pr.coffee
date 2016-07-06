# Description:
# get pr's that are ready for deployment
#
# Commands
# hubot reset msg interval <MINUTES> - reset the interval at which we check PRs
#

gtoken = process.env.HUBOT_TOKEN
room = process.env.HUBOT_HIPCHAT_ROOMS
urls = ["https://api.github.com/repos/Liaison-Intl/WebAdMIT/issues?labels=Ready%20for%20Release%20Master",
"https://api.github.com/repos/Liaison-Intl/webadmit_cas3_etl_loader/issues?labels=Ready%20for%20Release%20Master",
"https://api.github.com/repos/Liaison-Intl/webadmit_cas3_etl_transformer/issues?labels=Ready%20for%20Release%20Master"]
BUSINESS_DAY_NAMES = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
INTERVAL = 1000 * 60 * 60 * 5 # msec * sec * mn

module.exports = (robot) ->
  setInterval () ->
    now = new Date()
    day = now.getDay() - 1
    hour = now.getHours()
    if BUSINESS_DAY_NAMES[day] && hour >= 13 && hour <= 19
      for url in urls
        robot.http(url)
          .header('Accept', 'application/json')
          .header('Authorization', "token #{gtoken}")
          .get() (err, res, body) ->
            if err
              console.log "#{err} #{body}"
            else
              data = JSON.parse(body)
              if data?.length > 0
                prs = data.map (pr) -> pr.html_url
                handles = robot.brain.get('handles')
                if prs?.length > 0 && handles?.length > 0
                  resp = prs.join("\n")
                  robot.messageRoom room, "#{handles} #{resp}"
  , INTERVAL

  robot.respond /reset msg interval (\d+)/i, (msg) ->
    new_interval = msg.match[1]
    user = '@'+msg.message.user.mention_name
    handles = robot.brain.get('handles')
    if user in handles && new_interval
      reset = 1000 * 60 * new_interval
      robot.brain.set 'interval', reset
      msg.reply 'updated interval to ' + new_interval + ' minute(s)'
