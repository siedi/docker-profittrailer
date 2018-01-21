# docker-profittrailer
Dockerfile &amp; docker-compose for the ProfitTraler bot

Purpose of this repo is to 
- run the ProfitTrailer bot https://profittrailer.com/ multiple times (e.g. on the same exchange but with different accounts / currencies)
- put nginx in front to secure the connection with basic auth and https
- docker :-)


## Concept

The settings for the `application.properties` are mainly set via environment variables:
```
TELEGRAM_BOTTOKEN=
TELEGRAM_CHATID=
TRADING_EXCHANGE=
SERVER_TIMEZONEOFFSET=+00:00
SERVER_SITENAME=
SERVER_PASSWORD=
TRADING_LOGHISTORY=8
APIKEY=
APISECRET=
TRADING_APIKEY=
TRADING_APISECRET=
```
The corresponding template is `application.template`. You can either use those environment variables or just make your settings in the application.template. If you run the bot multiple times, you should use the envs, of course.

All the other configuration and database files should be mounted in the container (in theory one could mount the root directory, but that would mean others like logs as well). This is the list of files which should be mounted. 
```
configuration.properties
ProfitTrailerData.json
trading/*
```
All `*.properties` files can be changed according to the ProfitTrailer Wiki. The `ProfitTrailerData.json` holds your bot database. Initially it should just include en empty json `{}`

You find an example in `./pt1`.

## Running

First we will build the image
```
docker build -t docker-profittrailer .
```

And then we can run it
```
docker run -d \
    -p 8081:8081 \
    -v "${PWD}/pt1/ProfitTrailerData.json:/opt/ProfitTrailer/ProfitTrailerData.json" \
    -v "${PWD}/pt1/configuration.properties:/opt/ProfitTrailer/configuration.properties" \
    -v "${PWD}/pt1/trading/:/opt/ProfitTrailer/trading/" \
    -e TRADING_EXCHANGE=POLONIEX \
    -e SERVER_PASSWORD=MyVeryOwnPassword \
    -e APIKEY=abc \
    -e APISECRET=def \
    --name pt1 \
    docker-profittrailer
```

## docker-compose

As we want to run multiple bots and an nginx, we use docker-compose to assamble the stack (of course we could do it one by one as well). 
Please see the `docker-compose.yml`. It used the `jwilder/nginx-proxy` https://github.com/jwilder/nginx-proxy For instructions how to enable basic auth and ssl, please find the description there.




