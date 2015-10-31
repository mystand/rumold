ArgumentParser = require('argparse').ArgumentParser

parser = new ArgumentParser
  version: '1.0.1',
  addHelp: true,
  description: 'fast and simple mbtiles server'

parser.addArgument [ '--allow-origin' ],
  help: 'Set response access control headers to allow origin (default false)'
  action: 'storeTrue'
  defaultValue: false

parser.addArgument [ '--pid' ],
  help: 'PID file'

parser.addArgument [ '--port' ],
  help: 'Port (default 8888)'
  defaultValue: 8888

parser.addArgument [ '--socket' ],
  help: 'Unix socket to listen'

parser.addArgument [ '--tile-url' ],
  help: 'IP or hostname (default http://localhost:8888)'
  defaultValue: 'http://localhost:8888'

parser.addArgument ['tiles'],
  nargs: '*'
  help: 'list of .mbtiles'

module.exports = parser
