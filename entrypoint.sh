#!/bin/sh

set -x # verbose mode
set -e # stop executing after error

echo "Starting Jekyll build"

####################################################
# Set workspace permissions
####################################################

chmod -R a+w /github/workspace
git config --global --add safe.directory /github/workspace
echo $GITHUB_WORKSPACE

####################################################
# Build the Jekyll site
####################################################

jekyll build --trace

####################################################
# Build completed
####################################################

echo "Completed Jekll build"
