# Rumold

Rumold is a fast and simple mbtiles server.

[Rumold Mercator](http://en.wikipedia.org/wiki/Rumold_Mercator) (1545–1599) was a cartographer and the son of cartographer [Gerardus Mercator](http://en.wikipedia.org/wiki/Gerardus_Mercator).

## Getting Started

### Usage

```shell
usage: rumold [-h] [-v] [--allow-origin] [--pid PID] [--port PORT]
              [--socket SOCKET] [--tile-url TILE_URL]
              [tiles [tiles ...]]

fast and simple mbtiles server

Positional arguments:
  tiles                list of .mbtiles

Optional arguments:
  -h, --help           Show this help message and exit.
  -v, --version        Show programs version number and exit.
  --allow-origin       Set response access control headers to allow origin 
                       (default false)
  --pid PID            PID file
  --port PORT          Port (default 8888)
  --socket SOCKET      Unix socket to listen
  --tile-url TILE_URL  IP or hostname (default http://localhost:8888)
```

### Install using npm

```shell
npm install -g rumold
```

### Building from source

```shell
git clone https://github.com/mystand/rumold
cd rumold
npm install
npm run build
```

### Help

```shell
./bin/rumold -h
```
