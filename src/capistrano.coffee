FolderReader      = require './handler/FolderReader'
Capistrano        = require './handler/Capistrano'

if (!process.env.HUBOT_CAP_DIR)
  throw new Error 'You must define the env HUBOT_CAP_DIR'

folder     = new FolderReader process.env.HUBOT_CAP_DIR
cap        = new Capistrano

module.exports = (robot) ->

  robot.hear /(cap|capistrano) ([a-z0-9]+) (.*)/i, (msg) ->
    robot.brain.set('oe', 'a')
    stage = msg.match[2]
    command  = msg.match[3]

    cap.execute stage, command, msg
