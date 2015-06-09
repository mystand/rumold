_         = require 'underscore'
fs        = require 'fs'
url       = require 'url'
async     = require 'async'
merge     = require 'tilelive-merge'
blend     = require 'tilelive-blend'
mbtiles   = require 'mbtiles'
tilelive  = require 'tilelive'

mbtiles.registerProtocols(tilelive)

# Set URI

getURIs = (path) -> (callback) ->
  if fs.lstatSync(path).isDirectory()
    tilelive.list path, (error, tilestores) ->
      if error
        console.error error.message
        callback error
      else
        callback null, _(tilestores).values()
  else
    callback null, "mbtiles://#{path}"

setURI = (app, callback) ->
  paths = app.get('tiles')
  processors = _(paths).map getURIs
  async.series processors, (error, uris) ->
    if error
      console.error error.message
      callback error
    else
      uris = _(uris).chain().flatten().compact().value()
      uri = if uris.length > 1
        merge(tilelive)
        url.format
          protocol: 'merge:'
          query:
            sources: uris
      else _(uris).first()
      app.set('uri', uri)
      callback(null, app)

# Process meatadata

setMetadata = (app, callback) ->
  uri = app.get('uri')
  tilelive.info uri, (error, metadata, tilestore) ->
    if error
      console.error error.message
      callback error
    else
      format = metadata.format || 'png'
      metadata.tiles = []
      metadata.tiles.push app.get('tile-url') + '/{z}/{x}/{y}.' + format
      app.set('metadata', metadata)
      callback(null, app)

# Set source

setSource = (app, callback) ->
  uri = app.get('uri')
  tilelive.load uri, (error, source) ->
    if error
      console.error error.message
      callback error
    else
      app.set('source', source)
      callback(null, app)

# Setup

setup = (app) ->
  tasks = [
    (callback) -> setURI app, callback
    (callback) -> setMetadata app, callback
    (callback) -> setSource app, callback
  ]

  async.series tasks, (error, _) ->
    console.error error.message if error

module.exports.setup = setup