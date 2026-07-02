#!/bin/sh

set -x # verbose mode
set -e # stop executing after error

echo "Starting Jekyll build"

####################################################
# Set workspace permissions
####################################################

chmod -R a+w $GITHUB_WORKSPACE
git config --global --add safe.directory $GITHUB_WORKSPACE
export GIT_CEILING_DIRECTORIES=$GITHUB_WORKSPACE

####################################################
# Install dependencies and build the Jekyll site
####################################################

bundle install
bundle exec jekyll build --trace

####################################################
# Build completed
####################################################

echo "Completed Jekyll build"
