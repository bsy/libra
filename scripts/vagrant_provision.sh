#!/bin/sh

ERLANG_VERSION=19.2
ELIXIR_VERSION=1.4.0
NODE_VERSION=6

# Note: password is for postgres user "postgres"
POSTGRES_DB_PASS=postgres
POSTGRES_VERSION=9.6

# Set language and locale
apt-get install -y language-pack-en
locale-gen --purge en_US.UTF-8
echo "LC_ALL='en_US.UTF-8'" >> /etc/environment
dpkg-reconfigure locales

# Install basic packages
# inotify is installed because it's a Phoenix dependency
apt-get -qq update
apt-get install -y \
wget \
ca-certificates \
git \
unzip \
build-essential \
ntp \
inotify-tools

# Install Erlang
echo "deb http://packages.erlang-solutions.com/ubuntu trusty contrib" >> /etc/apt/sources.list && \
apt-key adv --fetch-keys http://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc && \
apt-get -qq update && \
apt-get install -y -f \
esl-erlang="1:${ERLANG_VERSION}"

# Install Elixir
apt-get install -y -f elixir="${ELIXIR_VERSION}-1"

# Install local Elixir hex and rebar for the vagrant user
su - vagrant -c '/usr/local/bin/mix local.hex --force && /usr/local/bin/mix local.rebar --force'

# Postgres
echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
apt-get update
apt-get -y install postgresql-$POSTGRES_VERSION postgresql-contrib-$POSTGRES_VERSION

PG_CONF="/etc/postgresql/$POSTGRES_VERSION/main/postgresql.conf"
echo "client_encoding = utf8" >> "$PG_CONF" # Set client encoding to UTF8
service postgresql restart

cat << EOF | su - postgres -c psql
ALTER USER postgres WITH ENCRYPTED PASSWORD '$POSTGRES_DB_PASS';
EOF

# Install nodejs and npm
curl -sL https://deb.nodesource.com/setup_$NODE_VERSION.x | sudo -E bash -
apt-get install -y nodejs

# Install imagemagick
apt-get install -y imagemagick

# Install PhantomJS
mkdir -p /tmp/phantomjs
curl -L https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 | tar -xj --strip-components=1 -C /tmp/phantomjs
mv /tmp/phantomjs/bin/phantomjs /usr/local/bin
chmod +x /usr/local/bin/phantomjs
