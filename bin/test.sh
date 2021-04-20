#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

readonly SCRIPT_DIR="$(cd "$(dirname "$0")"; pwd)"
readonly PROJECT_HOME="${SCRIPT_DIR}/.."

err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@" >&2
}

kill_jobs() {
  kill "$(jobs -p)"
}

main() {
  trap 'kill_jobs' ERR

  cd "${PROJECT_HOME}"

  cd socket-web-server
  ruby server.rb &
  sleep 1
  curl -f -v localhost:8000
  kill_jobs
  cd -

  cd socket-web-server
  ruby server_v2.rb &
  sleep 1
  curl -f -v localhost:8000
  kill_jobs
  cd -

  cd socket-web-application
  ruby server.rb &
  sleep 1
  curl -f -v localhost:8000
  kill_jobs
  cd -

  cd rails-generated-project
  bundle install
  yarn install
  bundle exec rails s &
  sleep 10
  curl -f -v localhost:3000
  kill_jobs
  cd -

  cd rack-application
  bundle install
  bundle exec rackup simple-config.ru &
  sleep 5
  curl -f -v localhost:9292
  kill_jobs
  cd -

  cd rack-application
  bundle install
  bundle exec rackup config.ru &
  sleep 5
  curl -f -v -L -d 'title=mytodo' localhost:9292/todos
  kill_jobs
  cd -

  cd rack-application-with-controller
  bundle install
  bundle exec rackup config.ru &
  sleep 5
  curl -f -v -L -d 'title=mytodo' localhost:9292/todos
  kill_jobs
  cd -

  cd rack-application-with-ajax
  bundle install
  bundle exec rackup config.ru &
  sleep 5
  curl -f -v localhost:9292/todos.html
  curl -f -v localhost:9292/todos.js
  curl -f -v localhost:9292/api/todos
  curl -f -v -d '{"title": "mytodo"}' localhost:9292/api/todos
  kill_jobs
  cd -
}

main "$@"
