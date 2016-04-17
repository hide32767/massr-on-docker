require 'serverspec'
require 'docker'
require 'yaml'

set :backend, :docker
set :docker_url, ENV["DOCKER_HOST"]
set :docker_image, 'massr'

Excon.defaults[:ssl_verify_peer] = false
