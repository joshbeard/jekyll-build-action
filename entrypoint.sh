#!/bin/sh

set -x # verbose mode
set -e # stop executing after error

echo "Starting Jekyll build"

####################################################
# Set workspace permissions
####################################################

chmod -R a+w $GITHUB_WORKSPACE
git config --global --add safe.directory $GITHUB_WORKSPACE

####################################################
# Build the Jekyll site
####################################################

jekyll --version
jekyll build --trace

####################################################
# Build completed
####################################################

echo "Completed Jekll build"
