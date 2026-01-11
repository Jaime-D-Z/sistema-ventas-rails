#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
# Comentamos la línea de assets:precompile
# bundle exec rake assets:precompile
# bundle exec rake assets:clean
bundle exec rake db:migrate
