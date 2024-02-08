steps:

install stable docker-desktop version: https://docs.docker.com/desktop/release-notes/#4260

start docker desktop

navigate to project

navigate to ./rails_root

run "docker compose up db" to start db and see logs (optional, run just "docker compose up" to run both rails development environment and database as docker containers)

run bundle install 

run rake db:setup

run rake db:migrate

run rails server

navigate to localhost:3000/posts to see post crud demo