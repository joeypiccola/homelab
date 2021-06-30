# owm_api

This is a simple [Flask-RESTful](https://flask-restful.readthedocs.io/en/latest/) API that fronts the Open Weather Map API's [Current Weather Data](https://openweathermap.org/current) endpoint. This was written as a PoC and to remove the Open Weather Map API's URL parameter token authentication. In other words, what was previously a `get` request is now a `post` where the API token is submitted via the payload.

## Usage [running]

When developing simply call the module directly.

`python3 owm.py`.

When running in Docker first build the image then run it and listen locally on `8080`.

`docker build -t "owm_api" .`

`docker run --rm -p 127.0.0.1:8080:5000/tcp owm_api`

Run it via the provided [docker-compose](https://docs.docker.com/compose/) file and listen locally on `8080`.

`docker-compose up`

## Usage [accessing]

Method: POST

URL: owm-api:8080/owm

Body Parameters.

|property|description|optional|default|
|--------|-----------|--------|-------|
|token|The [OpenWeatherMap API](https://openweathermap.org/api) token|`false`|-|
|zip_code|zip code to query|`false`|-|
|country|country code to query|`true`|`us`|
|units|units of measurement. `standard`, `metric` and `imperial`|`true`|`imperial`|

Example minimal JSON body.

```json
{
  "zip_code": "80209",
  "token": "----"
}
```
