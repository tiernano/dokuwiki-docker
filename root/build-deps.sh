#!/bin/bash
set -x
set -e

# This script is run during the base container build process only.
#
# It installs the OS and webserver dependencies and builds the required PHP extensions.
# The resulting container is DokuWiki independent and can be reused for different version containers.

# install additional packages
apt-get update
apt-get install -y --no-install-recommends \
        imagemagick \
        libapache2-mod-xsendfile \
        git 
apt-get autoclean

# install extensions
curl -sSLf -o install-php-extensions \
     https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions
chmod +x install-php-extensions
./install-php-extensions gd bz2 opcache pdo_sqlite intl ldap $PHP_EXTENSIONS
rm install-php-extensions
php -m

# remove package cache
apt-get clean

# delete self
rm -- "$0"
