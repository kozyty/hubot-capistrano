spawn   = require('child_process').spawn
carrier = require 'carrier'

class Capistrano
  execute: (project, stage, command, msg) ->
    path = process.env.HUBOT_CAP_DIR + project
    process.chdir(path);

    cap = spawn 'bundle', ['exec', 'cap', stage, command]
    @streamResult cap, msg

  streamResult: (cap, msg) ->
    capOut = carrier.carry cap.stdout
    capErr = carrier.carry cap.stderr
    output = ''

    capOut.on 'line', (line) ->
      output += line + "\n"

    capErr.on 'line', (line) ->
      output += "*" + line + "*\n"

    setInterval () ->
      if output != ""
        msg.send output.trim()
        output = ""
    , 10000

module.exports = Capistrano
