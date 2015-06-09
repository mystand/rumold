_           = require 'underscore'
path        = require 'path'
async       = require 'async'
utils       = require './utils'
parser      = require './parser'
express     = require 'express'
cachecache  = require 'cachecache'

args = parser.parseArgs()

app = express().disable('x-powered-by')
app.use cachecache()

app.set 'tiles',        _(args.tiles).map (tile) -> path.resolve tile
app.set 'port',         args.port
app.set 'socket',       args.socket
app.set 'tile-url',     args.tile_url
app.set 'allow-origin', args.allow_origin

# Set up app

utils.setup app

# Set headers
app.use (request, response, next) ->
  if app.get('allow-origin')
    response.header 'Access-Control-Allow-Origin', '*'
    response.header 'Access-Control-Allow-Headers',
                    'Origin, X-Requested-With, Content-Type, Accept'

  url = request.url
  remoteAddress = request.connection.remoteAddress
  console.log "#{remoteAddress} GET #{url}"
  next()

app.get '/source.tilejson', (request, response) ->
  metadata = app.get('metadata')
  response.send metadata

# Respond to tile request

tilePath = "/{z}/{x}/{y}.{format}"
tilePattern = tilePath.replace(/\.(?!.*\.)/, ":retina(@2x)?.")
                      .replace(/\./g, "\.")
                      .replace("{z}", ":z(\\d+)")
                      .replace("{x}", ":x(\\d+)")
                      .replace("{y}", ":y(\\d+)")
                      .replace("{format}", ":format([\\w\\.]+)");

app.get tilePattern, (request, response, next) ->
  z = parseInt(request.params.z)
  x = parseInt(request.params.x)
  y = parseInt(request.params.y)

  source = app.get('source')
  source.getTile z, x, y, (error, tile, headers) ->
    if error
      response.status 404
      response.send error.message
      console.error error.message
    else
      response.set headers
      response.send tile

module.exports = app