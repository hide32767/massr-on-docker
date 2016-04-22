# massr-on-docker

## overview

Dockerfile and spec for Massr, with 'development' environment.  
via. https://github.com/tdtds/massr

## require

- Docker environment
- several rubygems installed
 - rake
 - serverspec
 - docker-api

## notice

- It shall build the docker image by this Dockerfile, include MongoDB in the image.
  So when the docker container was stopped, all data of MongoDB shall be lost.
  If you want to save data of MongoDB, you should do 'docker commit' before you stop the docker container.
- If your Docker environment is provided by `docker-machine`, you should use your docker-machine IP address for accessing Massr.

## usage

set your Twitter API-key and Gmail account information to `dockerbuild_files/default.yaml` .

```
---
auth_twitter:
  :id: YOUR_TWITTER_API_KEY
  :secret: YOUR_TWITTER_API_SECRET
Gmail:
  mail: YOUR_GMAIL_ADDRESS
  pass: YOUR_GMAIL_APP_PASSWORD
```

build container, and test

```
$ docker build -t "massr" .
$ rake spec
```

run

```
$ docker run -d massr
```
