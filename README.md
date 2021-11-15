# Peak Analyzer

An `JSON API` backend tool for detecting peaks in instrument data.

## Technologies
RubyOnRails `6.1.4`, Ruby `3.0.2`, PostgreSQL, docker-compose, Docker.

External libraries: [Numo NArray](https://github.com/ruby-numo/numo-narray) for computing statistical methods `mean` and `stddev` efficiently.

## Setup

```bash
1. docker-compose build
2. docker-compose up
3. docker-compose exec web rails db:setup
```

1. Build `web` and `db` docker images
2. Start the containers. Rails server is mapped to `http://localhost:3000/`
3. Create databases: `instruments_data` and `instruments_data_test`

## Tests

The application was developed following _TDD_ principles. To run the specs: 

```bash
docker-compose exec web rspec
```

## Routes

```bash
docker-compose exec web rails routes
```

```
                  Prefix Verb URI Pattern                                    Controller#Action
peaks_api_series_samples GET  /api/series/:series_id/samples/peaks(.:format) api/samples#peaks
      api_series_samples GET  /api/series/:series_id/samples(.:format)       api/samples#index
                         POST /api/series/:series_id/samples(.:format)       api/samples#create
        api_series_index GET  /api/series(.:format)                          api/series#index
                         POST /api/series(.:format)                          api/series#create
                    root GET  /                                              redirect(301, /api/series)
```

## Usage

### Series

A device starts creating a `Serie` by hitting samples#create. Example using the `cURL` command:

```bash
curl -X POST http://localhost:3000/api/series
```

Response:
```json
{"id":1,"created_at":"2021-11-15T00:58:55.089Z","updated_at":"2021-11-15T00:58:55.089Z"}
```

All series can be listed using the `api/series#index` endpoint:

```bash
curl -X GET http://localhost:3000/api/series
```

Response:
```json
[{"id":1,"created_at":"2021-11-15T00:58:55.089Z","updated_at":"2021-11-15T00:58:55.089Z"}]
```

### Samples

From that moment on, the device can store its samples in the serie created in the previous step. Each sample contains a value:

```bash
curl -X POST http://localhost:3000/api/series/1/samples -H "Content-Type: application/json" --data '{"value": 12.5}'
```

Response:
```json
{"id":1,"serie_id":1,"value":"12.5","created_at":"2021-11-15T01:04:10.995Z","updated_at":"2021-11-15T01:04:10.995Z"}
```

All samples for a particular `Serie` can be listed using the `api/samples#peaks` endpoint:
```bash
curl -X GET http://localhost:3000/api/series/1/samples
```

Response:
```json
[{"id":1,"serie_id":1,"value":"12.5","created_at":"2021-11-15T01:04:10.995Z","updated_at":"2021-11-15T01:04:10.995Z"}]
```

### Motivation behind Series and Samples

Models are structured that way so data of devices is stored directly in the server and doesn't need to be sent over and over again via HTTP requests. That can be inefficient because of unnecessary repetition.

## Querying for peaks

At any point in time, a query can be made to `api/samples#peaks` to check if there are values with `z-score` above the given `threshold`.

For example, given the same initial data as in the _PDF_ use case description:

data = [1, 1.1, 0.9, 1,1, 1.2, 2.5, 2.3, 2.4, 1.1, 0.8, 1.2, 1]

And assuming that samples for each of those values have been already added to the server. Let's say to serie with `id = 2`.

Then, we can look for peaks by using:

```bash
curl -X GET http://localhost:3000/api/series/2/samples/peaks\?threshold\=1.0
```

Response:
[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, **1.0**, **1.0**, **1.0**, 0.0, 0.0, 0.0, 0.0]

### Window flag

Peaks endpoint supports an additional `window` parameter that lets you look for peaks taking only the last _window_ entries into account. 

For example, calling the endpoint with `window = 4`:
```bash
curl -X GET http://localhost:3000/api/series/2/samples/peaks\?threshold\=1.0\&window\=4
```

Will only analyze the subset of last 4 elements. In this case `[1.1, 0.8, 1.2, 1]`, resulting in:

```
[0.0, 0.0, 1.0, 0.0]
```
