fs      = require 'fs'
npid    = require 'npid'
http    = require 'http'
parser  = require './parser'

args = parser.parseArgs()

unless args.tiles.length > 0
  console.error 'No tiles specified, terminating'
  process.exit -1

if args.pid
  try
    pid = npid.create args.pid
    pid.removeOnExit()
  catch error
    console.log error.message
    console.error "Can't manage PID file #{args.pid}, terminating"
    process.exit -1

app = require './app'

# Start server
handle = app.get('socket') || app.get('port')
server = http.createServer(app).listen handle, () ->
  fs.chmodSync app.get('socket'), '1766' if app.get('socket')
  console.log "Server started on #{handle}"

# Catch SIGINT (Ctrl+C) to exit process
process.on 'SIGINT', () ->
  console.warn 'Caught SIGINT, terminating'
  server.close()
  process.exit()