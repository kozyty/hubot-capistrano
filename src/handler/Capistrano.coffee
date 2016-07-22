slack   = require 'hubot-slack'
exec   = require('child_process').exec

class Capistrano
  execute: (stage, command, msg, robot) ->
    process.chdir(process.env.HUBOT_CAP_DIR);

    msg.send "Now #{stage} deploying..."
    exec "bundle exec cap #{stage} #{command} | tail -n 50", (err, stdout, stderr) ->
      if err
        unless robot.adapter instanceof slack.SlackBot
          msg.send "Error: deployed #{stage}"
        else
          robot.emit 'slack.attachment',
            message: msg.message
            content: [{
              color: "warning"
              mrkdwn_in: ["text", "pretext", "fields"]
              title: "Cannot deployed #{stage}"
              text: "```#{stderr}```"
              fields: [{
                title: "Status"
                value: "error"
                short: false
              }]
              footer: "hubot"
              footer_icon: "https://hubot.github.com/assets/images/layout/hubot-avatar@2x.png"
              ts: msg.message.rawMessage.ts
            }]
      else
        unless robot.adapter instanceof slack.SlackBot
          msg.send "Success: deployed #{stage}"
        else
          robot.emit 'slack.attachment',
            message: msg.message
            content: [{
              color: "good"
              mrkdwn_in: ["text", "pretext", "fields"]
              title: "Deployed #{stage}"
              text: "```#{stdout}```"
              fields: [{
                title: "State"
                value: "success"
                short: false
              }],
              footer: "hubot"
              footer_icon: "https://hubot.github.com/assets/images/layout/hubot-avatar@2x.png"
              ts: msg.message.rawMessage.ts
            }]

module.exports = Capistrano
