#!/bin/bash
# Terminate execution if any command fails
set -e

# Get tag from a script argument
TAG=$1
GIT_REMOTE_URL='here should be a remote url of the repo'
BASE_DIR=/opt/demo

# Create folder structure for releases if necessary
RELEASE_DIR=$BASE_DIR/releases/$TAG
mkdir -p $RELEASE_DIR
mkdir -p $BASE_DIR/storage
cd $RELEASE_DIR

# Fetch the release files from git as a tar archive and unzip
git archive \
    --remote=$GIT_REMOTE_URL \
    --format=tar \
    $TAG \
    | tar xf -

# Install laravel dependencies with composer
composer install -o --no-interaction --no-dev

# Create symlinks to `storage` and `.env`
ln -sf $BASE_DIR/.env ./
rm -rf storage && ln -sf $BASE_DIR/storage ./

# Run database migrations
php artisan migrate --no-interaction --force

# Run optimization commands for laravel
php artisan optimize
php artisan cache:clear
php artisan route:cache
php artisan view:clear
php artisan config:cache

# Remove existing directory or symlink for the release and create a new one.
NGINX_DIR=/var/www/public
mkdir -p $NGINX_DIR
rm -f $NGINX_DIR/demo
ln -sf $RELEASE_DIR $NGINX_DIR/demo

# Use Example
# deploy.sh v1.0.3